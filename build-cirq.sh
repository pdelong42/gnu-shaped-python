#!/bin/bash

# Usage:
#
# script -c ./build.sh $(date +%F_%T).log

set -xeuo pipefail

PACKAGE=cirq
CODEPENDENCIES="setuptools cirq-core[contrib]"
VERSION=3.12.8
# cannot upgrade to latest Python version yet, because modules (or depedencies) fail to build there
#VERSION=3.13.2
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

# The URL referenced earlier also advises the installation of packages outside
# of the Python runtime.  It was couched in terms of Debian-based package
# management, so I'll have to adapt this to RPM-based package names when I get
# around to it.
#
#sudo apt-get install texlive-latex-base latexmk
