# Intel SoCFPGA Golden Software Reference Design (SM TSN Config-3)

GSRD is an Embedded Linux Reference Distribution optimized for SoCFPGA.  
It is based on Yocto Project Poky reference distribution.

## Meta Layers

* meta-intel-fpga - SoCFPGA BSP Core Layer
* meta-intel-fpga-refdes - SoCFPGA GSRD Customization Layer
* meta-sm-tsn-cfg3 - SoCFPGA GSRD Customization Layer for SM TSN CONFIG-3 Solution (QUARTUS 24.3/212 - KERNEL 6.6.37)

Dependencies
* poky - Core Layer from Yocto Project
* meta-openembedded - Additional features (python, networking tools, etc) for GSRD

## Using The Script

## Supported Image Variant:  

|    Target                  |              Image                           |
| -------------------------- | -------------------------------------------- |
| Agilex5 DK-A5E065BB32AES1  |   gsrd [ qspi + emmc ]                       |

## SM TSN Config-3 GSRD Setup

1. Clone the repository
`$ git clone git@github.com:altera-fpga/agilex5-ed-tsn-sgmii.git

2. Sync the submodules
`$ cd agilex5-ed-tsn-sgmii/src/sw`
`$ git submodule update --init -r`

3. Run the agilex5_dk_a5e065bb32aes1-gsrd-build.sh script to sync the submodules
`$ . agilex5_dk_a5e065bb32aes1-gsrd-build.sh`

4. Run the build_setup to setup build environment
`$ build_setup`

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
