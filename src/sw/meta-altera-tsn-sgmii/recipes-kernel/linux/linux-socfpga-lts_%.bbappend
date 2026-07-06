SUMMARY = "Intel SoCFPGA Development Kit Linux Kernel layer for TSN Config-3(TSN SGMII) Example Designs"
DESCRIPTION = "Linux Kernel addons for TSN Config-3(TSN SGMII) Example Designs on Intel SoCFPGA Development Kits"
SECTION = "kernel"

LICENSE = "MIT & GPL-2.0-only"

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-socfpga-lts:"

# Append GSRD specific kernel config fragments
SRC_URI:append:agilex5_mk_a5e065bb32aes1 =      " \
        ${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://nf.scc', '', d)} \
        ${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://fit_kernel_agilex5_mk_a5e065bb32aes1_gsrd.its', '', d)} \
        ${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://0001-net-stmmac-socfpga-Add-MRPHY-soft-PCS-support.patch', '', d)} \
        ${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://0002-net-stmmac-socfpga-Expose-MRPHY-latency-registers-vi.patch', '', d)} \
        ${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://0003-net-stmmac-socfpga-Add-MRPHY-Dynamic-Reconfiguration.patch', '', d)} \
	${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://0004-net-mdio-Add-Altera-MDIO-controller-driver.patch', '', d)} \
	${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://0005-net-phy-phy_caps-Advertise-sub-2500-speeds-for-2500B.patch', '', d)} \
	${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://0006-arm64-dts-agilex5-Add-TSN-config-3-support-with-Dyna.patch', '', d)} \
	${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://0007-net-stmmac-dwxgmac2-Add-1G-CRC-workaround-for-Altera.patch', '', d)} \
	${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://0008-net-stmmac-fix-TX-queue-timeout-caused-by-disabling-NAPI.patch', '', d)} \
	"
do_deploy[depends] += "hw-ref-design:do_deploy"

do_deploy:append() {
	# Stage required binaries for kernel.it
	# Supported device family:
	#                               -       Agilex5
	# TSN Config-3: start linux-socfpga MACHINE is ${MACHINE} and IMAGE_TYPE is ${IMAGE_TYPE}

	if [ "${MACHINE}" = "agilex5_mk_a5e065bb32aes1" ]; then
		# linux.dtb
		cp ${DTBDEPLOYDIR}/socfpga_agilex5_socdk_tsn_cfg3_dr.dtb ${B}/socfpga_agilex5_socdk_tsn_cfg3_dr.dtb
		# core.rbf
		cp ${DEPLOY_DIR_IMAGE}/${MACHINE}_${IMAGE_TYPE}_ghrd/ghrd.core.rbf ${B}
		#deploy kernel itb
		cp ${WORKDIR}/fit_kernel_${MACHINE}_${IMAGE_TYPE}.its ${B}
		# Image
		cp ${LINUXDEPLOYDIR}/Image ${B}
                # Compress Image to lzma format
		if [ -e ${B}/Image.lzma ]; then
			rm ${B}/Image.lzma
		fi
                xz --format=lzma -f ${B}/Image
                # Generate kernel.itb
                mkimage -f ${B}/fit_kernel_${MACHINE}_${IMAGE_TYPE}.its ${B}/kernel.itb
                # Deploy kernel.its, kernel.itb and Image.lzma
                install -m 744 ${B}/fit_kernel_${MACHINE}_${IMAGE_TYPE}.its ${DEPLOYDIR}
                install -m 744 ${B}/kernel.itb ${DEPLOYDIR}
                install -m 744 ${B}/Image.lzma ${DEPLOYDIR}
		exit 0
	fi
}

