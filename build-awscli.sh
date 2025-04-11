#!/bin/bash

# Usage:
#
# script -c ./build.sh $(date +%F_%T).log

# this is mostly a pointless exercise, because it only installs AWS CLI v1, and
# v2 isn't available via any widely-accepted package/module management system

set -xeuo pipefail

PACKAGE=awscli
CODEPENDENCIES=
VERSION=3.13.2
NAME=Python-${VERSION}
TARBALL=${NAME}.tar.xz
URL=https://www.python.org/ftp/python/${VERSION}/${TARBALL}
STUFF=${HOME}/Stuff
PREFIX=${STUFF}/Builds/${NAME}/${PACKAGE}
BIN=${PREFIX}/bin
MAKE="make -j"

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
$MAKE
$MAKE test
$MAKE install

${BIN}/python3 -m pip install --upgrade pip $PACKAGE $CODEPENDENCIES
