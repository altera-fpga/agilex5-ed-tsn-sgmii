FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:agilex5_dk_a5e065bb32aes1 = " \
		file://prgm_mrphy_delay_app \
		file://README_mrphy_delay_app \
		"


FILES:${PN} += "/home/root/prgm_mrphy_delay_app \
	        /home/root/README_mrphy_delay_app \
	       "

do_install:append() {
	cd ${S}
	if [[ "${MACHINE}" == *"agilex5"* ]]; then
		install -m 0755 ${WORKDIR}/prgm_mrphy_delay_app ${D}/home/root/prgm_mrphy_delay_app
		install -m 0755 ${WORKDIR}/README_mrphy_delay_app ${D}/home/root/README_mrphy_delay_app
	fi
}
