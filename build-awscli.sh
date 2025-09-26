#!/bin/bash

# Usage:
#
# script -c ./build.sh $(date +%F_%T).log

# this is mostly a pointless exercise, because it only installs AWS CLI v1, and
# v2 isn't available via any widely-accepted package/module management system

set -xeuo pipefail

DISTROVERSION=3.13.7
DISTNAME=Python-${DISTROVERSION}
DISTTAR=${DISTNAME}.tar.xz
DISTURL=https://www.python.org/ftp/python/${DISTROVERSION}/${DISTTAR}

PACKAGEVERSION=2.31.2
PACKNAME=aws-cli-${PACKAGEVERSION}
PACKTAR=${PACKAGEVERSION}.tar.gz
PACKURL=https://github.com/aws/aws-cli/archive/refs/tags/${PACKTAR}

STUFF=${HOME}/Stuff
PREFIX=${STUFF}/Builds/${DISTNAME}/${PACKNAME}
BIN=${PREFIX}/bin
MAKE="make -j"

OLDDIR=${PWD}
SCRATCH=$(mktemp -d)

function cleanup {
   rm -rvf $SCRATCH
}

trap cleanup HUP INT STOP TERM QUIT EXIT

cd $SCRATCH

wget $DISTURL

tar Jxv < $DISTTAR

pushd $DISTNAME

./configure --prefix=${PREFIX}
$MAKE
$MAKE test
$MAKE install

#ncp config.log $OLDDIR

popd

PIPINST="${BIN}/python3 -m pip install"

wget $PACKURL

tar zxv < $PACKTAR

pushd $PACKNAME

$PIPINST --upgrade pip
$PIPINST -r requirements-dev-lock.txt
$PIPINST .
#$PIPINST -e .

#aws --version
#./scripts/gen-ac-index --include-builtin-index
#aws --cli-auto-prompt
