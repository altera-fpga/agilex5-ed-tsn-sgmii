#!/bin/bash
set -e
umask 022

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT
cd "$WORKDIR"
echo "$FLAG_DIR"
TSN_CFG3_SM72_CORE_RBF=$WORKDIR/src/sw/meta-altera-tsn-sgmii/recipes-bsp/ghrd/files/agilex5_mk_a5e065bb32aes1_gsrd_ghrd.core.rbf

git init
git remote add origin "$GITHUB_SERVER_URL"/"$GITHUB_REPOSITORY"
git fetch origin "$GITHUB_REF"
git checkout FETCH_HEAD

if [ -n "$FLAG_DIR" ];then
    if [[ -f "$FLAG_DIR/hardware_done" ]]; then
        echo "Hardware build is completed."
        ls -lrt $FLAG_DIR/../hw/*core.rbf
        cp -rf $FLAG_DIR/../hw/*core.rbf $TSN_CFG3_SM72_CORE_RBF
        sha1sum $FLAG_DIR/../hw/*core.rbf
        sha1sum $TSN_CFG3_SM72_CORE_RBF
        ls -lrt $TSN_CFG3_SM72_CORE_RBF
    else
        echo "Hardware build did not completed."
        exit 1
    fi
fi

cd src/sw
mkdir -vp "$SSTATE_DIR"
ln -vsnfT "$SSTATE_DIR" sstate_cache

. agilex5_mk_a5e065bb32aes1-gsrd-build.sh
build_setup
bitbake_image
package

cd agilex5_mk_a5e065bb32aes1-gsrd-images
mkdir -vp "$DESTDIR"
#cp -vt "$DESTDIR" gsrd-console-image-agilex5.tar.gz kernel.itb sdimage.tar.gz u-boot-agilex5-socdk-gsrd-atf/u-boot-spl-dtb.hex u-boot-agilex5-socdk-gsrd-atf/u-boot.itb Image socfpga_agilex5_socdk_tsn_cfg3.dtb agilex5_gsrd_ghrd/ghrd.core.rbf agilex5_gsrd_ghrd/ghrd.hps.rbf
cp -vt "$DESTDIR" gsrd-console-image-agilex5.tar.gz kernel.itb sdimage.tar.gz