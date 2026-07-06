FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:agilex5_dk_a5e065bb32aes1 = " \
					     file://tsn-delay-config.c \
					     file://README_tsn-delay-config \
					   "

SRC_URI:append:agilex5_mk_a5e065bb32aes1 = " \
                                             file://tsn-delay-config.c \
                                             file://README_tsn-delay-config \
                                           "

FILES:${PN} += "/home/root/tsn-delay-config \
                /home/root/README_tsn-delay-config \
               "

do_compile:append() {
	cd ${S}
	if [[ "${MACHINE}" == *"agilex5"* ]]; then
		${CC} ${CFLAGS} ${LDFLAGS} ${WORKDIR}/tsn-delay-config.c -o ${WORKDIR}/tsn-delay-config
	fi
}

do_install:append() {
	cd ${S}
	if [[ "${MACHINE}" == *"agilex5"* ]]; then
		install -m 0755 ${WORKDIR}/tsn-delay-config ${D}/home/root/tsn-delay-config
		install -m 0744 ${WORKDIR}/README_tsn-delay-config ${D}/home/root/README_tsn-delay-config
	fi
}
