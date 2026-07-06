#! /bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "Entering shell"

REQ_ARC_RES=$(sed -z 's/\n/ /g' $SCRIPT_DIR/arc_resource.txt)
env ACDS_DEV_KIT_OVERRIDE=0 arc shell $REQ_ARC_RES

