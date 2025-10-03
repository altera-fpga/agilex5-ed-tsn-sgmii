# Agilex 5 TSN Config3 System Reference Design

This directory contains the Quartus Project for the Agilex 5 TSN System Design with Multirate Ethernet Phy IP 3x2.5G ports

# Dependency

- Quartus® Prime 25.1.1
- Supported Board:
  - [Agilex™ 5 FPGA E-Series 065B Modular Development Kit](https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/a5e065b-modular.html)

# Build Steps

 1. Compile design and generate configuration file:

    ```
	quartus_sh --flow compile a5ed065bb32ae6sr0
    ```
## Programming Files Generation Steps
1) Get your boot loader .hex file 
2) Generate binary file including boot loader files and the jic file using following commands
   ```bash
   quartus_pfg -c -o hps_path=u-boot.hex ./output_files/a5e065bb32aes1.sof ./output_files/a5e065bb32aes1.sof
   quartus_pfg -c -o hps=on ./output_files/a5e065bb32aes1.sof ./output_files/a5e065bb32aes1.rbf
   quartus_pfg -c -o mode=ASX4 -o device=MT25QU02G -o flash_loader=A5ED065BB32AE6SR0 -o hps_path=u-boot.hex ./output_files/a5ed065bb32ae6sr0.sof ./output_files/a5ed065bb32ae6sr0.jic
   ```




