#!/usr/bin/env python3
"""Script to boot HPS to linux on an OscarBB farm and then
interact with the console.

"""
import sys
import subprocess

import pexpect
from oscar_test import (net_boot_linux, gdb_net_boot_linux,
                        create_boot_linux_args_parser, handle_boot_linux_args)

def run_test(console):
    console.logfile = None
    print('interacting')
    console.interact()
    return 0


def main():
    """Entry point of test case"""
    args = create_boot_linux_args_parser().parse_args()

    [uart_cmd, qpgm, nfs_root_path] = handle_boot_linux_args(args)

    subprocess.check_call(qpgm)

    ret = 0
    with pexpect.spawn(uart_cmd) as console:
        console.logfile = sys.stdout.buffer

        if args.openocd_cfg and args.gdb_cmd:
            ret = gdb_net_boot_linux(console, args, nfs_root_path)
        else:
            ret = net_boot_linux(console, args, nfs_root_path)

        if not ret:
            run_test(console)

    sys.exit(ret)


if __name__ == '__main__':
    sys.stdout.reconfigure(line_buffering=True)
    main()
