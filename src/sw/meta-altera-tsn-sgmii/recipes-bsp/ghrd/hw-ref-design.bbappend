SUMMARY = "Intel SoCFPGA Development Kit Linux Kernel layer for TSN Config-3(TSN SGMII) Example Designs"
DESCRIPTION = "Linux Kernel addons for TSN Config-3(TSN SGMII) Example Designs on Intel SoCFPGA Development Kits"
SECTION = "bsp"

LICENSE = "MIT & GPL-2.0-only"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

ARM64_GHRD_HPS_RBF = "ghrd.hps.rbf"


SRC_URI:agilex5_mk_a5e065bb32aes1 = "\
                        file://agilex5_mk_a5e065bb32aes1_gsrd_ghrd.core.rbf;name=agilex5_mk_a5e065bb32aes1_gsrd_core_cfg3 \
                        file://agilex5_mk_a5e065bb32aes1_gsrd_ghrd.hps.rbf;name=agilex5_mk_a5e065bb32aes1_gsrd_hps_cfg3 \
                        "

SRC_URI[agilex5_mk_a5e065bb32aes1_gsrd_core_cfg3.sha256sum] = "486c18b4e0c190fe86ab6cbbb9db7dbd90abba8e4bfb9e637252adc9ea8f38e5"
SRC_URI[agilex5_mk_a5e065bb32aes1_gsrd_hps_cfg3.sha256sum] = "7916d4ff0e9123c4971fa681bff09474054520a350c1f23d7f43240fcb6f71cc"

do_install() {
	if [ "${MACHINE}" == "agilex5_mk_a5e065bb32aes1" ]; then
                install -D -m 0644 ${WORKDIR}/${MACHINE}_${IMAGE_TYPE}_${ARM64_GHRD_CORE_RBF} ${D}/boot/${ARM64_GHRD_CORE_RBF}
	fi
}

do_deploy() {
        if [ "${MACHINE}" == "agilex5_mk_a5e065bb32aes1" ]; then
                install -D -m 0644 ${WORKDIR}/${MACHINE}_${IMAGE_TYPE}_${ARM64_GHRD_CORE_RBF} ${DEPLOYDIR}/${MACHINE}_${IMAGE_TYPE}_ghrd/${ARM64_GHRD_CORE_RBF}
                install -D -m 0644 ${WORKDIR}/${MACHINE}_${IMAGE_TYPE}_${ARM64_GHRD_HPS_RBF} ${DEPLOYDIR}/${MACHINE}_${IMAGE_TYPE}_ghrd/${ARM64_GHRD_HPS_RBF}
        fi

}

