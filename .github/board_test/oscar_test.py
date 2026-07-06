"""Module of utility functions using the oscar_remote command.

"""
import argparse
import os
import re
import subprocess
import sys
import tempfile
import time

import pexpect

UPROMPT_RE = r'SOCFPGA_(.*) # '
uprompt = [UPROMPT_RE, pexpect.EOF, pexpect.TIMEOUT]
lprompt = [r'\[root\] # ', pexpect.EOF, pexpect.TIMEOUT]

gdb_script="""
#
# Copyright (c) 2021 Intel Corporation
#
# SPDX-License-Identifier: MIT-0
#

#
# this script assumes that it starts with the Cortex A53 running the default
# hps_debug.ihex image as the FSBL that was loaded during the initial device
# configuration
#

#
# these are the external file references that are required in this script, you
# may need to edit these for your particular environment
#
# software/u-boot-socfpga/spl/u-boot-spl-dtb.bin
# software/u-boot-socfpga/spl/u-boot-spl
# software/u-boot-socfpga/u-boot.itb
# software/u-boot-socfpga/u-boot
#

#
# restore the binary image for the u-boot-spl FSBL program into the HPS OCRAM
# and start it running to the board_boot_order function
#
shell date
restore {spl_dtb_bin} binary 0xFFE00000
shell date

symbol-file -readnow {spl}
set $pc=0xffe00000
hbreak board_boot_order
cont
del

#
# save x0, it contains a pointer to the spl_boot_device array, then return from
# the function
#
set var $THE_PTR = $x0
set var $THE_LR = $lr
hbreak *$THE_LR
cont
del

#
# set the first entry of the spl_boot_device array to 0, indicating RAM boot
#
set *$THE_PTR = 0

#
# restore the binary image for the SSBL, u-boot + ATF, FIT image, into DRAM
#
shell date
restore {u_boot_itb} binary 0x02000000
shell date
symbol-file -readnow {u_boot}

#
# run to the relocate_code function so we can reload our symbols after the
# u-boot code is relocated
#
hbreak relocate_code
cont
del

#
# save the value of the relocation offset passed in through x0, and run to the
# return location of this function, this will be at the relocated code position
#
set var $THE_PTR = $x0
set var $THE_LR = $lr
hbreak *$THE_LR
cont
del

#
# reload the symbol file with the relocation offset so that it maps to the
# relocated position
#
symbol-file -readnow {u_boot} -o '$THE_PTR - 0x00200000'

#
set var default_environment = "bootcmd=while true;do;dcache flush;source 00100000:script;done"

#
# run to initr_env so we can force the default environment to be loaded
#
# hbreak initr_env
cont

"""


def get_jtag_device():
    """Parse jtagconfig to obtain JTAG device for programming.

    Returns index of JTAG device, or None otherwise.
    """
    output = subprocess.check_output(["jtagconfig", "--cable", "1"], text=True)
    print(output)

    index = None
    for line in output.splitlines():
        if line.startswith('1) '):
            index = 0
            continue
        if index is None:
            continue

        cols = line.split(None, 2)
        if len(cols) != 2:
            break

        code, name = cols
        if name == 'VTAP10':
            return index

        index += 1

    return None

def get_uart_cmd():
    """Get command to access the DUT's UART.

    returns pexpect handle on success, or None otherwise.
    """
    output = subprocess.check_output(['oscar_remote', '--portfwd', 'uart'])
    output1 = output.decode('utf-8')
    print(output.decode('utf-8'))

    pattern = re.compile(r"Requested\s+Uart=ttyUSB0:.*?Port=\d+.*?To open a console run:\s+(telnet\s+[^\s]+\s+\d+)", re.DOTALL)
    match =pattern.search(output1)
    if match is None:
        print("failed to find console command")
        sys.exit(1)
    print(f'{match.group(1)}')
    return match.group(1)


def get_blade_tunnel(port=22):
    """get info for a TCP tunnel to the blade
    """
    output = subprocess.check_output(['oscar_remote', '--portfwd',
                                      f'blade:{port}'])
    print(output.decode('utf-8'))

    match = re.search(r'Forwarded	Address=(\S*)\s*Port=(\d*)',
                      output.decode('utf-8'), re.MULTILINE)
    if match is None:
        print("failed to create blade tunnel")
        sys.exit(1)
    print(f'{match.group(1)} {match.group(2)}')
    return [match.group(1), match.group(2)]


def copy_to_tftpboot(host, port, filepath):
    """Copy file to tftpboot directory"""
    # Check if the file exists in the local directory
    if not os.path.isfile(filepath):
        print(f"Error: File '{filepath}' does not exist.")
        sys.exit(1)
        
    cmd = ['scp', '-o', 'StrictHostKeyChecking=no', '-o', 'UserKnownHostsFile=/dev/null',
           '-P', port, filepath, f'root@{host}:/var/lib/tftpboot']
    print(" ".join(cmd))
    subprocess.check_call(cmd)

def untar_rootfs(nfs_root_tgz):
    """untar nfs root file system

    nfs_root_tgz - path to gzipped tarball

    returns "nfsroot=ip:path" on success, None otherwise
    """

    script = os.path.join(os.path.dirname(__file__), 'oscar_remote_temp.py')
    cmd = ['python3', script, '--untar_rootfs', nfs_root_tgz]
    print(" ".join(cmd))

    output = subprocess.check_output(cmd)

    print(output.decode('utf-8'))

    match = re.search(r'(nfsroot=\S*$)', output.decode('utf-8'), re.MULTILINE)
    if match is None:
        print("failed to find nfs_root_path")
        sys.exit(1)

    print(f'nfs_root_path is {match.group(0)}')
    return match.group(0)


def power_cycle(sleep_time=5.0):
    """Perform a oscar_remote based power cycle"""
    subprocess.check_call(['oscar_remote', '--poweroff'])
    time.sleep(sleep_time)
    subprocess.check_call(['oscar_remote', '--poweron'])

def wait_for_uboot(console, timeout=120):
    """Wait for U-boot prompt. Interrupt autoboot if necessary

    console - pexect object to HPS console UART

    Returns 0 on success, non-zero otherwise
    """

    print('starting uboot')
    ustart = ['Hit any key to stop autoboot:',
              UPROMPT_RE, pexpect.EOF, pexpect.TIMEOUT]

    index = console.expect(ustart, timeout=timeout)
    if index == 0:
        console.sendline('')
        index = console.expect(uprompt, timeout=5)
        if index != 0:
            print("failed to get U-boot prompt")
            return 1

    elif index >= 2:
        print(f"failed to interrupt U-boot: {index}")
        return 1

    prompt = console.match.group(0)

    con_send_cmd(console, 'env default -f -a', uprompt)
    if con_send_cmd(console, 'env default -f -a', uprompt):
        return 1

    if con_send_cmd(console, 'printenv', uprompt):
        return 1

    if prompt == b'SOCFPGA_AGILEX5 # ':
        cmd = 'setenv -f eth2addr f8:e4:3b:9a:63:ae'
    else:
        cmd = 'setenv -f ethaddr ee:d3:42:f8:cf:3e'

    if con_send_cmd(console, cmd, uprompt):
        return 1

    return 0

def wait_for_linux_and_login(console, timeout=120):
    """Wait for login prompt, login, and set prompt.

    console - pexect object to HPS console UART

    Returns 0 on success, non-zero otherwise
    """
    login_prompt = ['login: ', pexpect.EOF, pexpect.TIMEOUT]
    index = console.expect(login_prompt, timeout=timeout)
    if index != 0:
        print(f'failed to see login: {index}')
        return 1

    console.sendline('root')

    first_prompt = [r'root.*# ', pexpect.EOF, pexpect.TIMEOUT]
    index = console.expect(first_prompt, timeout=5)
    if index != 0:
        print(f'failed to see first prompt: {index}')
        return 1

    console.sendline("PS1='[root] # '")
    exp = [r"PS1=\S+ # ", pexpect.EOF, pexpect.TIMEOUT]
    index = console.expect(exp, timeout=5)
    if index != 0:
        print(f'failed to see setting prompt: {index}')
        return 1

    index = console.expect(lprompt, timeout=5)
    if index != 0:
        print(f'failed to see lprompt: {index}')
        return 1

    return 0


def validate_file_is_readable(filepath):
    """Ensure a file path exists and is readable.

    returns valid filename, raises argparse.ArgumentTypeError otherwise
    """
    if not os.path.isfile(filepath):
        raise argparse.ArgumentTypeError(f"'{filepath} is not a valid file.")
    if not os.access(filepath, os.R_OK):
        raise argparse.ArgumentTypeError(f"'{filepath} is not readable.")
    return filepath


def con_send_cmd(con, cmd, prompt, timeout=5):
    """Send a command on a console connection and wait for prompt.

    con - pexpect connection to linux console
    cmd - command string to send
    prompt - expected prompt string
    timeout - timeout in seconds waiting for prompt

    Returns 0 on success, non-zero otherwise
    """

    con.sendline(cmd)
    index = con.expect(prompt, timeout=timeout)
    if index != 0:
        print(f"command, {cmd}, failed: {index}")

    return index

def copy_file_to_ram(console, server_ip, filepath):
    """Copy a single file from TFTP server to RAM using U-Boot commands."""
   
    # Extract the filename from the filepath
    filename = os.path.basename(filepath)

    con_send_cmd(console, f'setenv netmask 255.255.255.0', uprompt, timeout=10)
    con_send_cmd(console, f'setenv serverip {server_ip}', uprompt, timeout=10)
    con_send_cmd(console, f'setenv ipaddr 192.168.1.1', uprompt, timeout=10)

    cmd = f'tftpboot {server_ip}:{filename}'
    if con_send_cmd(console, cmd, uprompt, timeout=45):
        print(f'Failed to load {filename} to RAM')
        return 1
    return 0

def copy_file_to_sdcard(console, filepath):
    """Copy a single file from RAM to SD card using U-Boot commands."""

    # Extract the filename from the filepath
    filename = os.path.basename(filepath)

    cmd = f'fatwrite mmc 0:1 $loadaddr {filename} $filesize'
    if con_send_cmd(console, cmd, uprompt, timeout=45):
        print(f'Failed to write {filename} to SD card')
        return 1
    return 0

def load_file_from_sdcard(console, filepath):
    """Load a single file from SD card to RAM using U-Boot commands."""

    # Extract the filename from the filepath
    filename = os.path.basename(filepath)
    
    cmd = f'fatload mmc 0:1 $loadaddr {filename}'
    if con_send_cmd(console, cmd, uprompt, timeout=45):
        print(f'Failed to load {filename} from SD card to RAM')
        return 1
    return 0

def net_boot_linux(console, args, nfs_root_path, uboot_timeout=120):
    """Drive U-boot to boot linux over the network.

    console - pexpect object to HPS console
    args - command line arguments

    Returns 0 on success, non-zero otherwise
    """
          
    if args.jtag_device is None:
        jtag_device = get_jtag_device()
    else:
        jtag_device = args.jtag_device

    if jtag_device is None:
        sys.exit('missing JTAG device') 
    
    if wait_for_uboot(console, timeout=uboot_timeout) > 0:
        return 1
    
    copy_file_to_ram(console, args.server_ip, args.core_rbf)
    copy_file_to_sdcard(console, args.core_rbf)

    copy_file_to_ram(console, args.server_ip, args.hps_rbf)
    copy_file_to_sdcard(console, args.hps_rbf)
    
    copy_file_to_ram(console, args.server_ip, args.kernel_itb)
    copy_file_to_sdcard(console, args.kernel_itb)

    if args.copy_extra_files is not None:
        for file in args.copy_extra_files:
            copy_file_to_ram(console, args.server_ip, file)
            copy_file_to_sdcard(console, file)

    con_send_cmd(console, "fatls mmc 0:1", uprompt, timeout=45) #to see all the files in the sdcard to see if the files were all copied over to the sdcard successfully

    con_send_cmd(console, "^]", uprompt, timeout=45) #to exit out of UART

    #program with tsn rbf now
    qpgm = ['quartus_pgm', '-c', '1', '-m', 'jtag', '-o', f'p;{args.hps_rbf}@{jtag_device}']
    subprocess.check_call(qpgm)

    if wait_for_uboot(console, timeout=uboot_timeout) > 0:
        return 1

    load_file_from_sdcard(console, args.core_rbf)
    
    if args.core_rbf:
        if con_send_cmd(console, 'dcache flush', uprompt):
            return 1

        if con_send_cmd(console, 'fpga load 0 $loadaddr $filesize', uprompt):
            return 1

        match = re.search('FPGA reconfiguration OK!',
                          console.before.decode('utf-8'), re.MULTILINE)
        if match is None:
            return 1

        if con_send_cmd(console, 'bridge enable', uprompt):
            return 1

    if args.kernel_itb is None:
        return 0

    load_file_from_sdcard(console, args.kernel_itb)    

    if args.mmc_root:
        #cmd = 'setenv bootargs earlycon panic=-1 root=/dev/mmcblk0p2 rw rootwait mem=2G'
        cmd = 'setenv bootargs earlycon panic=-1 root=/dev/mmcblk0p2 rw rootwait'

    elif nfs_root_path is not None:
        cmd = 'setenv bootargs earlycon panic=-1 root=/dev/nfs ' \
              f'{nfs_root_path},nfsvers=3,tcp rw ip=:::::eth0:dhcp'

    else:
        return 0

    if con_send_cmd(console, cmd, uprompt):
        return 1

    if args.kernel_itb_conf is None:
        return 0

    console.sendline(f'bootm $loadaddr#{args.kernel_itb_conf}')

    if wait_for_linux_and_login(console):
        return 1

    return 0

def gdb_net_boot_linux(console, args, nfs_root_path, uboot_timeout=60*20):
    """Drive load run U-boot with gdb to boot linux over the network.

    console - pexpect object to HPS console
    args - command line arguments
    nfs_root_path - ip:path to nfs root file system
    uboot_timeout - timeout to see u-boot prompt

    Returns 0 on success, non-zero otherwise
    """
    ports = []
    ret = 1
    with pexpect.spawn(f'openocd -f {args.openocd_cfg}') as openocd:
        openocd.logfile = sys.stdout.buffer

        ocd = [r'Listening on port (\d*) for gdb connections', pexpect.EOF, pexpect.TIMEOUT]
        for i in range(4):
            index = openocd.expect(ocd, timeout=10)
            if index != 0:
                print('failed to see Listening on port from openocd')
                openocd.terminate()
                return 1

            ports.append(openocd.match.group(1))

        print(ports)
        port = ports[0].decode('utf-8')
        with tempfile.NamedTemporaryFile(delete=False) as tempf:
            temp_name = tempf.name;
            print(f'tempfile is {temp_name}')
            script = gdb_script.format(spl_dtb_bin=args.spl_dtb_bin, spl=args.spl,
                                       u_boot_itb=args.u_boot_itb, u_boot=args.u_boot)
            print(script)
            tempf.write(script.encode('utf-8'))
            tempf.close()

            gdb = [args.gdb_cmd, '--batch', '-ex',  'set arch aarch64',
                   '-ex', 'set remotetimeout 60', '-ex', f'target extended-remote localhost:{port}',
                   '--command',  temp_name]
            print(gdb)
            with subprocess.Popen(gdb):
                ret = net_boot_linux(console, args, nfs_root_path, uboot_timeout=uboot_timeout)
                openocd.terminate()
                os.remove(temp_name)

    return ret

def create_boot_linux_args_parser():
    '''Create a base parse for oscar remote booting linux'''
    descr = "Script to boot HPS to linux via U-boot script in FIT"

    parser = argparse.ArgumentParser(description=descr)

    script_help = "name of u-boot script to load over net and run"
    parser.add_argument('--kernel-itb', help=script_help,
                        required=False, type=validate_file_is_readable)

    parser.add_argument('--kernel-itb-conf', help='boot configuration listed in itb',
                        required=False)

    parser.add_argument('--server-ip', help='IP address of TFTP server',
                        default='192.168.1.50')

    parser.add_argument('--jtag-device', help='jtag device index',
                        required=False, type=int)

    parser.add_argument('--ghrd-rbf', help='ghrd hps.rbf to load via jtag',
                        required=True, type=validate_file_is_readable)

    parser.add_argument('--hps-rbf', help='tsn hps.rbf to load via jtag',
                        required=True, type=validate_file_is_readable)

    parser.add_argument('--core-rbf', help='tsn core.rbf to load via tftp',
                        required=False, type=validate_file_is_readable)

    parser.add_argument('--power-cycle', help='power cycle DUT before test',
                        action='store_true')

    parser.add_argument('--copy-extra-files', help='list of extra files to copy to tftp server and sdcard',
                        nargs='+', type=validate_file_is_readable)

    parser.add_argument('--nfs-root-tgz', help='gzipped tarball of NFS root file system',
                        required=False, type=validate_file_is_readable)

    parser.add_argument('--nfs-root-path', help='ip:path to NFS root file system',
                        required=False)

    parser.add_argument('--mmc-root', help='use /dev/mmcblk0p1 as root file system',
                        action='store_true')

    parser.add_argument('--openocd-cfg', help='path to OpenOCD config file',
                        default=None, type=validate_file_is_readable)

    parser.add_argument('--gdb-cmd', help='Command to start gdb',
                        default=None)

    parser.add_argument('--spl-dtb-bin', help='path to u-boot-spl-dtb.bin file',
                        default=None, type=validate_file_is_readable)

    parser.add_argument('--spl', help='path to u-boot-spl file',
                        default=None, type=validate_file_is_readable)

    parser.add_argument('--u-boot-itb', help='path to u-boot.itb file',
                        default=None, type=validate_file_is_readable)

    parser.add_argument('--u-boot', help='path to u-boot file',
                        default=None, type=validate_file_is_readable)

    return parser


def handle_boot_linux_args(args):
    """Handle the arguments created by create_boot_linux_args_parser

    args - output of parse_args()

    exits on failure, [uart_cmd, qpgm, nfs_root_path] otherwise
    """

    if args.openocd_cfg and args.gdb_cmd:
        if not args.spl_dtb_bin or not args.spl or not args.u_boot_itb or not args.u_boot:
            print('Options --openocd-cfg and --gdb-cmd require --spl-dtb-bin --spl --u-boot-itb --u-boot')
            sys.exit(1)

    if args.nfs_root_tgz:
        nfs_root_path = untar_rootfs(args.nfs_root_tgz)
    elif args.nfs_root_path:
        nfs_root_path = args.nfs_root_path
    else:
        nfs_root_path = None

    if args.power_cycle:
        print('power cycling DUT')
        power_cycle()

    [host, port] = get_blade_tunnel()

    cmd = ['ssh', '-o', 'StrictHostKeyChecking=no', '-o', 'UserKnownHostsFile=/dev/null',
           '-p', port, f'root@{host}', 'rm', '-rf', '/var/lib/tftpboot/*']
    print(" ".join(cmd))
    subprocess.check_call(cmd)


    print(f'host is: {host}')
    
    if args.copy_extra_files is not None:
        for file in args.copy_extra_files:
            copy_to_tftpboot(host, port, file)

    copy_to_tftpboot(host, port, args.core_rbf)
    copy_to_tftpboot(host, port, args.hps_rbf)
    copy_to_tftpboot(host, port, args.kernel_itb)
    
    if args.jtag_device is None:
        jtag_device = get_jtag_device()
    else:
        jtag_device = args.jtag_device

    if jtag_device is None:
        sys.exit('missing JTAG device')    

    
    uart_cmd = get_uart_cmd()
    qpgm = ['quartus_pgm', '-c', '1', '-m', 'jtag', '-o', f'p;{args.ghrd_rbf}@{jtag_device}']

    return [uart_cmd, qpgm, nfs_root_path]


