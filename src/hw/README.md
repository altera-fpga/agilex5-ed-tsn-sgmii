# Agilex 5 TSN Config3 System Reference Design Build Scripts

Agilex 5 TSN Config3 Syatem is a reference design for Intel Agilex System On Chip (SoC) FPGA. It works together with Golden Software Reference design (GSRD) for complete solution to boot Uboot and Linux with Intel SoC Development board. 

This reference design demonstrating the following system integration between Hard Processor System (HPS) and FPGA IPs:
- Hard Processor System enablement and configuration
  - HPS Peripheral and I/O (eg, NAND, SD/MMC, EMAC, USB, SPI, I2C, UART, and GPIO)
  - HPS Clock and Reset
  - HPS FPGA Bridge and Interrupt
- HPS EMIF configuration
- System integration with FPGA IPs
  - TSN subsystem that consists of MRPHY IP, PLLs and user registers for MRPHY control and status indications.
  - Peripheral subsystem that consists of System ID, sSGDMA IP for data movement, Programmable I/O (PIO) IP for controlling DIPSW, PushButton, and LEDs. Optionally to enable DFL ROM for OFS peripherals information discovery
  - Debug subsystem that consists of JTAG-to-Avalon Master IP to allow System-Console debug activity and FPGA content access through JTAG
  - FPGA On-Chip Memory
  - Optional Nios subsystem that consists of NiosV, its execution RAM (FPGA DDR or Onchip Memory), and Mailbox Simple FPGA IP as a medium of communication with HPS
	
This repository hosts build scripts for AGILEX 5 TSN Config3 System reference design.

## Dependency
* Intel Quartus Prime 23.4
* Supported Board
  - Intel Agilex 5 Premium Development Kit

## Build Steps
The TSN config3 is built with Makefile.
1) Retrive the default parameterization of the project
   ```bash
   make config
   ```
2) Generate Quartus Project and source files. [Not neccesary if step 3 is applied]
    ```bash
    make H2F_WIDTH=0 F2SDRAM_DATA_WIDTH=0 generate_from_tcl
    ```
3) Compile Quartus Project and generate the configuration file
    ```bash
    make H2F_WIDTH=0 F2SDRAM_DATA_WIDTH=0 all
    ```
## Programming Files Generation Steps
1) Get your boot loader .hex file 
2) Generate binary file including boot loader files using following commands
   ```bash
   quartus_pfg -c -o hps_path=u-boot.hex ./output_files/ghrd_a5ed065bb32ae6sr0.sof ./output_files/ghrd_a5ed065bb32ae6sr0.sof
   quartus_pfg -c -o hps=on ./output_files/ghrd_a5ed065bb32ae6sr0.sof ./output_files/ghrd_a5ed065bb32ae6sr0.rbf
   ```
3) Generate configuration file
   ```bash
   quartus_pfg -c -o mode=ASX4 -o device=MT25QU02G -o flash_loader=A5ED065BB32AE6SR0 -o hps_path=u-boot.hex ghrd_a5ed065bb32ae6sr0.sof ghrd_a5ed065bb32ae6sr0.jic
   ```

