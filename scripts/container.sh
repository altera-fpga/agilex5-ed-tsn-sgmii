#!/bin/sh
#
# Build a Singularity container image from a given definition file,
# using the EC (engineering computing) container build environment.
#
# https://altera-corp.atlassian.net/wiki/spaces/tdmaInfra/pages/94737701/Container+Development+in+EC+environment
#
set -eux

def=$1 # Singularity definition file
sif=$2 # Singularity image file

chmod 1777 /tmp
cp "$def" /tmp/container.def
singularity build /tmp/container.sif /tmp/container.def
install --mode=644 --no-target-directory /tmp/container.sif "$sif"
