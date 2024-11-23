
do_configure:append() {
	if [[ "${MACHINE}" == *"agilex5_"* ]]; then
		if [[ "${MACHINE}" == "agilex5_dk_a5e065bb32aes1" ]]; then
			# GSRD DTB Generation
			# TSN CONFIG3
			cp ${STAGING_KERNEL_DIR}/arch/${ARCH}/boot/dts/intel/socfpga_agilex5_socdk_tsn_cfg3.dts ${WORKDIR}/socfpga_agilex5_socdk_tsn_cfg3.dts
			sed -i '/\#include \"socfpga_agilex5.dtsi\"/a \#include \"socfpga_agilex5_ghrd.dtsi\"' ${WORKDIR}/socfpga_agilex5_socdk_tsn_cfg3.dts
		fi
	fi
}

