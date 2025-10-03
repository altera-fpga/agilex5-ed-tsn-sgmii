SUMMARY = "Intel SoCFPGA Development Kit Linux Kernel layer for TSN Config-3(TSN SGMII) Example Designs"
DESCRIPTION = "Linux Kernel addons for TSN Config-3(TSN SGMII) Example Designs on Intel SoCFPGA Development Kits"
SECTION = "bsp"

LICENSE = "MIT & GPL-2.0-only"

do_configure:append() {
        # TSN CONFIG-3: device-tree MACHINE is ${MACHINE} and IMAGE_TYPE is ${IMAGE_TYPE}

	if [ "${MACHINE}" = "agilex5_dk_a5e065bb32aes1" ] || [ "${MACHINE}" = "agilex5_mk_a5e065bb32aes1" ]; then
		# GSRD DTB Generation
		cp ${STAGING_KERNEL_DIR}/arch/${ARCH}/boot/dts/intel/socfpga_agilex5_socdk_tsn_cfg3.dts ${WORKDIR}/sources/socfpga_agilex5_socdk_tsn_cfg3.dts
		sed -i '/\#include \"socfpga_agilex5.dtsi\"/a \#include \"socfpga_agilex5_ghrd.dtsi\"' ${WORKDIR}/sources/socfpga_agilex5_socdk_tsn_cfg3.dts
	fi
}

