# Yocto Project layer with Agilex™ 5 TSN - SGMII XCVR System Example Design (SM TSN Config-3)

This directory contains a Yocto Project layer with the [Agilex™ 5 TSN - SGMII XCVR System Example](https://github.com/intel-innersource/applications.fpga.system-example-designs.agilex5e-ed-tsn-config3) for the [Intel® SoCFPGA Golden Software Reference Design (GSRD)](https://github.com/altera-opensource/gsrd-socfpga).

## Meta Layers

* meta-intel-fpga - SoCFPGA BSP Core Layer
* meta-intel-fpga-refdes - SoCFPGA GSRD Customization Layer
* meta-altera-tsn-sgmii - SoCFPGA Customization Layer for SM TSN CONFIG-3 Solution (QUARTUS 25.1.1 - KERNEL 6.12.19 lts)

Dependencies
* poky - Core Layer from Yocto Project
* meta-openembedded - Additional features (python, networking tools, etc) for GSRD

## Supported Targets:  

|    Board                                               |   OPN             |    Image                |
| ------------------------------------------------------ | ----------------- | ----------------------- | 
| Agilex™ 5 FPGA E-Series Premium Development Kit        | DK-A5E065BB32AES1 |   gsrd [ qspi + emmc ]  |
| ------------------------------------------------------ | ----------------- | ----------------------- |
| Agilex™ 5 FPGA E-Series Modular Development Kit        | MK-A5E065BB32AES1 |   gsrd [ qspi + emmc ]  |


## SM TSN Config-3 GSRD Setup
1. Clone the repository and checkout to release branch rel/25.1.1 .
`$ git clone https://github.com/intel-innersource/applications.fpga.soc.agilex5e-ed-tsn-config3.git`
`$ cd applications.fpga.soc.agilex5e-ed-tsn-config3`
`$ git checkout rel/25.1.1`
`$ cd src/sw`


2. Source the script to set component versions (Linux, U-Boot, ATF, Machine, Image):

|    Target                  |              Command                            |
| -------------------------- | ----------------------------------------------- |
| Agilex5 DK-A5E065BB32AES1  |   `$ . agilex5_dk_a5e065bb32aes1-gsrd-build.sh`                      |
| -------------------------- | ----------------------------------------------- |
| Agilex5 MK-A5E065BB32AES1  |   `$ . agilex5_mk_a5e065bb32aes1-gsrd-build.sh`|


3. Run the build_setup to setup build environment
`$ build_setup`


4. OPTIONAL:  CUSTOM GHRD:

              a. Add custom GHRD design in the below path:
                   $WORKSPACE/src/sw/meta-altera-tsn-sgmii/recipes-bsp/ghrd/files/
                   NOTE: Update/Replace the GHRD core rbf file with the same naming convention given below
                            For Agilex5 DK-A5E065BB32AES1:-
                                          agilex5_dk_a5e065bb32aes1_gsrd_ghrd.core.rbf
                            For Agilex5 MK-A5E065BB32AES1:-
                                          agilex5_mk_a5e065bb32aes1_gsrd_ghrd.core.rbf

              b. Update SRC_URL in the below recipe:
                    $WORKSPACE/src/sw/meta-altera-tsn-sgmii/recipes-bsp/ghrd/hw-ref-design.bbappend
                    Note: Update the SRC_URL using the example below
                           Include the required file with sha256sum
                        Example:-

			For Agilex5 DK-A5E065BB32AES1:-
			SRC_URI:agilex5_dk_a5e065bb32aes1 += "\
					file://agilex5_dk_a5e065bb32aes1_gsrd_ghrd.core.rbf;name=agilex5_dk_a5e065bb32aes1_gsrd_core_cfg3 \
					"
			SRC_URI[agilex5_dk_a5e065bb32aes1_gsrd_core_cfg3.sha256sum] += "xxxxxx"

   			For Agilex5 MK-A5E065BB32AES1:-
   			SRC_URI:agilex5_mk_a5e065bb32aes1 += "\
   					file://agilex5_mk_a5e065bb32aes1_gsrd_ghrd.core.rbf;name=agilex5_mk_a5e065bb32aes1_gsrd_core_cfg3 \
   					"
   			SRC_URI[agilex5_mk_a5e065bb32aes1_gsrd_core_cfg3.sha256sum] += "xxxxxx"


6. Perform Yocto bitbake to generate binaries
`$ bitbake_image`


7. Package binaries into build folder
`$ package`
