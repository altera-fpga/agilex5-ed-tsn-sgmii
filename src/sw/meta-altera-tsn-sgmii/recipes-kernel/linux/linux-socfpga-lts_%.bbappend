SUMMARY = "Intel SoCFPGA Development Kit Linux Kernel layer for TSN Config-3(TSN SGMII) Example Designs"
DESCRIPTION = "Linux Kernel addons for TSN Config-3(TSN SGMII) Example Designs on Intel SoCFPGA Development Kits"
SECTION = "kernel"

LICENSE = "MIT & GPL-2.0-only"

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-socfpga-lts:"

# Append GSRD specific kernel config fragments
SRC_URI:append:agilex5_dk_a5e065bb32aes1 =	" \
	${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://nf.scc', '', d)} \
	${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://fit_kernel_agilex5_dk_a5e065bb32aes1_gsrd.its', '', d)} \
        ${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://0001-SM-TSN-Config-3-code-changes.patch', '', d)} \
        ${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://0002-PK-Config-3-SinglePhy-1x2.5G-Device-tree-changes.patch', '', d)} \
	${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://0004-workaround-for-1G-crc-error.patch', '', d)} \
	"

SRC_URI:append:agilex5_mk_a5e065bb32aes1 =      " \
        ${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://nf.scc', '', d)} \
        ${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://fit_kernel_agilex5_mk_a5e065bb32aes1_gsrd.its', '', d)} \
        ${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://0001-SM-TSN-Config-3-code-changes.patch', '', d)} \
        ${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://0002-Add-Altera-MDIO-driver-support.patch', '', d)} \
        ${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://0003-MK-Config-3-concurrent-3x2.5G-Device-tree-changes.patch', '', d)} \
	${@bb.utils.contains('IMAGE_TYPE', 'gsrd', 'file://0004-workaround-for-1G-crc-error.patch', '', d)} \
	"
do_deploy[depends] += "hw-ref-design:do_deploy"

do_deploy:append() {
	# Stage required binaries for kernel.it
	# Supported device family:
	#                               -       Agilex5
	# TSN Config-3: start linux-socfpga MACHINE is ${MACHINE} and IMAGE_TYPE is ${IMAGE_TYPE}

	if [ "${MACHINE}" = "agilex5_dk_a5e065bb32aes1" ] || [ "${MACHINE}" = "agilex5_mk_a5e065bb32aes1" ]; then
		# linux.dtb
		cp ${DTBDEPLOYDIR}/socfpga_agilex5_socdk.dtb ${B}
		cp ${DTBDEPLOYDIR}/socfpga_agilex5_vanilla.dtb ${B}
		cp ${DTBDEPLOYDIR}/socfpga_agilex5_socdk_tsn_cfg3.dtb ${B}/socfpga_agilex5_socdk.dtb
		# core.rbf
		cp ${DEPLOY_DIR_IMAGE}/${MACHINE}_${IMAGE_TYPE}_ghrd/ghrd.core.rbf ${B}
		#deploy kernel itb
		cp ${WORKDIR}/sources-unpack/fit_kernel_${MACHINE}_${IMAGE_TYPE}.its ${B}
		# Image
		cp ${LINUXDEPLOYDIR}/Image ${B}
                # Compress Image to lzma format
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

