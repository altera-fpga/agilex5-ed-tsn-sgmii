#!/bin/sh
set -ex

QUARTUS_VERSION=acdskit/26.1

if [ -n "$BUILD_PATH" ]; then
    arc shell $QUARTUS_VERSION -- "quartus_sh --version" | awk -F',' '/entering shell with resources/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}'  > $BUILD_PATH/quartus_info
fi

DIR=$PWD
HEX_PATH="$PWD/src/sw/artifacts/u-boot-spl-dtb.hex"

cd src/hw/a5e065bb32aea_mdk_3x2.5G/
arc shell $QUARTUS_VERSION -- 'quartus_sh --flow compile top.qpf -c top'

# we pick socfpga_refdes from GHRD release 25.1 RC8 build 
arc shell $QUARTUS_VERSION -- "quartus_pfg -c -o hps_path=$HEX_PATH ./output_files/top.sof ./output_files/top_hps.sof"
arc shell $QUARTUS_VERSION -- 'quartus_pfg -c -o hps=on ./output_files/top_hps.sof ./output_files/mdk_3x2.5G.rbf'
