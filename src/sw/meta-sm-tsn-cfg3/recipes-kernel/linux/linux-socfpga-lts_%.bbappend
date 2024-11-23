FILESEXTRAPATHS:prepend := "${THISDIR}/linux-socfpga-lts:"
# Append GSRD specific kernel config fragments
SRC_URI:append:agilex5_dk_a5e065bb32aes1 =	" file://0001-SM-TSN-Config-3-code-changes.patch \
						  file://0002-Config-3-MRPHY-Device-tree-changes.patch \
						  file://nf.scc "

inherit deploy

LINUXDEPLOYDIR = "${WORKDIR}/deploy-${PN}"
DTBDEPLOYDIR = "${DEPLOY_DIR_IMAGE}/devicetree"

do_deploy:append() {
        # Stage required binaries for kernel.itb
        # Supported device family:
        #                               -       Agilex5

        if [[ "${MACHINE}" == *"agilex5_"* ]]; then
                # linux.dtb
                if [ "${MACHINE}" == "agilex5_dk_a5e065bb32aes1" ]; then
                        # linux.dtb
                        cp ${DTBDEPLOYDIR}/socfpga_agilex5_socdk_tsn_cfg3.dtb ${B}/socfpga_agilex5_socdk.dtb
                        # core.rbf
                        cp ${DEPLOY_DIR_IMAGE}/${MACHINE}_${IMAGE_TYPE}_ghrd/ghrd.core.rbf ${B}
                fi
        fi
        # Generate and deploy kernel.itb
        if [[ "${MACHINE}" == *"agilex5_"* ]]; then
                # kernel.its
                cp ${WORKDIR}/fit_kernel_${MACHINE}.its ${B}
                # Image
                cp ${LINUXDEPLOYDIR}/Image ${B}
                # Compress Image to lzma format
                xz --format=lzma -f ${B}/Image
                # Generate kernel.itb
                mkimage -f ${B}/fit_kernel_${MACHINE}.its ${B}/kernel.itb
                # Deploy kernel.its, kernel.itb and Image.lzma
                install -m 744 ${B}/fit_kernel_${MACHINE}.its ${DEPLOYDIR}
                install -m 744 ${B}/kernel.itb ${DEPLOYDIR}
                install -m 744 ${B}/Image.lzma ${DEPLOYDIR}
        fi
}

