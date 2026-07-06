# Yocto Project layer with Agilex™ 5 TSN - SGMII XCVR System Example Design (SM TSN Config-3) - Quartus 26.1 release

This directory contains a Yocto Project layer with the [Agilex™ 5 TSN - SGMII XCVR System Example](https://github.com/intel-innersource/applications.fpga.system-example-designs.agilex5e-ed-tsn-config3) for the [Intel® SoCFPGA Golden Software Reference Design (GSRD)](https://github.com/altera-opensource/gsrd-socfpga).

## Meta Layers

* meta-intel-fpga - SoCFPGA BSP Core Layer
* meta-intel-fpga-refdes - SoCFPGA GSRD Customization Layer
* meta-altera-tsn-sgmii - SoCFPGA Customization Layer for SM TSN CONFIG-3 Solution (QUARTUS 26.1 - KERNEL 6.18.2)

Dependencies
* poky - Core Layer from Yocto Project
* meta-openembedded - Additional features (python, networking tools, etc) for GSRD

## Supported Targets:  

|    Board                                               |   OPN             |    Image                |
| ------------------------------------------------------ | ----------------- | ----------------------- |
| Agilex™ 5 FPGA E-Series Modular Development Kit        | MK-A5E065BB32AEA  |   gsrd [ qspi + emmc ]  |


## SM TSN Config-3 GSRD Setup
1. Clone the repository and checkout to release branch rel/26.1:

    ```
    $ git clone https://github.com/altera-fpga/agilex5-ed-tsn-sgmii
    $ cd agilex5-ed-tsn-sgmii
    $ git checkout rel/26.1
    $ cd src/sw
    ```


2. Source the script to set component versions (Linux, U-Boot, ATF, Machine, Image):

    |    Target                  |              Command                            |
    | -------------------------- | ----------------------------------------------- |
    | Agilex5 MK-A5E065BB32AEA   |   `$ . agilex5_mk_a5e065bb32aes1-gsrd-build.sh` |

    ```
    PLEASE NOTE- The script agilex5_mk_a5e065bb32aes1-rped-build.sh is used to generate the yocto build for MK-A5E065BB32AEA.
    ```

3. Run the build_setup to setup build environment

    ```
    $ build_setup
    ```


4. OPTIONAL:  CUSTOM GHRD:

              a. Copy the generated custom GHRD RBF files (top.hps.rbf and top.core.rbf) in the below path::
                   $WORKSPACE/src/sw/meta-altera-tsn-sgmii/recipes-bsp/ghrd/files/
                   ```
                   NOTE: Rename the GHRD top.hps.rbf and top.core.rbf files to match the exact naming convention specified below
                            For Agilex5 MK-A5E065BB32AEA:-
                                          agilex5_mk_a5e065bb32aes1_gsrd_ghrd.hps.rbf
                                          agilex5_mk_a5e065bb32aes1_gsrd_ghrd.core.rbf
                   ```

              b. Update sha256sum value of the custom hps and core rbf files:
                    ```
                    Note: calculate the sha256sum of the hps and core rbf using the below commands
                          sha256sum agilex5_mk_a5e065bb32aes1_gsrd_ghrd.hps.rbf
                          sha256sum agilex5_mk_a5e065bb32aes1_gsrd_ghrd.core.rbf
                    ```

                    Update the sha256sum values of hps and core rbf got from above commands in the below recipe-
                    $WORKSPACE/src/sw/meta-altera-tsn-sgmii/recipes-bsp/ghrd/hw-ref-design.bbappend
                    ```
                    For Agilex5 MK-A5E065BB32AEA:-
                        SRC_URI[agilex5_mk_a5e065bb32aes1_gsrd_hps_cfg3.sha256sum] += "<put the above calculated hps sha256sum here>"
                        SRC_URI[agilex5_mk_a5e065bb32aes1_gsrd_core_cfg3.sha256sum] += "<put the above calculated core sha256sum here>"
                    ```

    ```
    PLEASE NOTE- The naming agilex5_mk_a5e065bb32aes1 is used to generate the yocto build binaries for MK-A5E065BB32AEA.
    ```

6. Perform Yocto bitbake to generate binaries
    ```
    bitbake_image
    ```


7. Package binaries into build folder
    ```
    package
    ```
