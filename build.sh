#!/bin/bash

echo "Building project $1:$2"

set -x -e

/opt/mplabx/mplab_platform/bin/prjMakefilesGenerator.sh "$1@$2"
make -C "$1" CONF="$2" build
