#!/bin/bash

# Usage:
#
# script -c ./build.sh $(date +%F_%T).log

# For the moment, this is very specific to the Cirq use-case.  But I intend to
# come back and generalize this, and make bits of it into more reusable chunks.

set -xeuo pipefail

VERSION=3.12.8
NAME=Python-${VERSION}
TARBALL=${NAME}.tar.xz
URL=https://www.python.org/ftp/python/${VERSION}/${TARBALL}
STUFF=${HOME}/Stuff
PREFIX=${STUFF}/Builds/${NAME}-pyzx
BIN=${PREFIX}/bin
PIPINST="${BIN}/python3 -m pip install"

SCRATCH=$(mktemp -d)

function cleanup {
   rm -rvf $SCRATCH
}

trap cleanup HUP INT STOP TERM QUIT EXIT

cd $SCRATCH

wget $URL

tar Jxv < $TARBALL

cd $NAME

./configure --prefix=${PREFIX}
make
make test 
make install

$PIPINST --upgrade pip
$PIPINST pyzx
