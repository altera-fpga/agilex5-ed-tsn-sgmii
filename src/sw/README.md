# Intel SoCFPGA Golden Software Reference Design

GSRD is an Embedded Linux Reference Distribution optimized for SoCFPGA.  
It is based on Yocto Project Poky reference distribution.

## Meta Layers

* meta-intel-fpga - SoCFPGA BSP Core Layer
* meta-intel-fpga-refdes - SoCFPGA GSRD Customization Layer
* meta-sm-tsn-cfg3 - SoCFPGA GSRD Customization Layer for SM TSN CONFIG-3 Solution (QUARTUS 24.3/194 - KERNEL 6.6.37)

Dependencies
* poky - Core Layer from Yocto Project
* meta-openembedded - Additional features (python, networking tools, etc) for GSRD

## Using The Script
#### [Default GSRD Setup](#default-gsrd-setup-1)  
#### [Default GSRD Setup with eSDK](#default-gsrd-setup-with-esdk-1)  
#### [Custom GSRD Setup](#custom-gsrd-setup-1)  

## Supported Image Variant:  

|    Target                  |              Image                           |
| -------------------------- | -------------------------------------------- |
| Agilex5 DK-A5E065BB32AES1  |   gsrd [ qspi + emmc ]                       |


## Custom GSRD Setup
1. Clone the repository and checkout to release branch rel/24.3 .
`$ git clone https://github.com/intel-innersource/applications.fpga.soc.agilex5e-ed-tsn-config3.git`
`$ cd applications.fpga.soc.agilex5e-ed-tsn-config3`
`$ git checkout rel/24.3`


2. Run the agilex5_dk_a5e065bb32aes1-gsrd-build.sh script from src/sw to sync the submodules
`$ cd src/sw`
`$ . agilex5_dk_a5e065bb32aes1-gsrd-build.sh`


3. Run the build_setup to setup build environment
`$ build_setup`


4. Update the srcrev of Linux, uboot and atf in recipe files below:
   -meta-intel-fpga/recipes-kernel/linux/linux-socfpga-lts_6.6.bb
   -meta-intel-fpga/recipes-bsp/arm-trusted-firmware/arm-trusted-firmware_v2.11.bb
   -meta-intel-fpga/recipes-bsp/u-boot/u-boot-socfpga_v2024.04.bb

   The srcrev can be taken from the latest commit in link below:
   -Linux: Commits · https://github.com/intel-innersource/applications.fpga.soc.linux-socfpga/commits/socfpga-6.6.37-lts
   -u-boot: Commits · https://github.com/intel-innersource/applications.fpga.soc.uboot-socfpga/commits/socfpga_v2024.04
   -ATF: Commits · https://github.com/intel-innersource/applications.fpga.soc.arm-trusted-firmware/commits/socfpga_v2.11.0


5. OPTIONAL:  GHRD:

              a. Add custom GHRD design in the below path:
                   $WORKSPACE/src/sw/meta-sm-tsn-cfg3/recipes-bsp/ghrd/files/
                   NOTE: Update/Replace the GHRD core rbf file with the same naming convention given below
                            For Agilex5 DK-A5E065BB32AES1:-
                                          agilex5_dk_a5e065bb32aes1_gsrd_ghrd.core.rbf

              b. Update SRC_URL in the below recipe:
                    $WORKSPACE/src/sw/meta-sm-tsn-cfg3/recipes-bsp/ghrd/hw-ref-design.bbappend
                    Note: Update the SRC_URL using the example below
                           Include the required file with sha256sum
                        Eg:-
			SRC_URI:agilex5_dk_a5e065bb32aes1 += "\
					file://agilex5_dk_a5e065bb32aes1_gsrd_ghrd.core.rbf;name=agilex5_dk_a5e065bb32aes1_gsrd_core_cfg3 \
					"
			SRC_URI[agilex5_dk_a5e065bb32aes1_gsrd_core_cfg3.sha256sum] += "xxxxxx"


6. Perform Yocto bitbake to generate binaries
`$ bitbake_image`


7. Package binaries into build folder
`$ package`
