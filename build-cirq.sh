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
PREFIX=${STUFF}/Builds/${NAME}
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

# the rest is cribbed from https://quantumai.google/cirq/start/install

$PIPINST --upgrade pip
$PIPINST cirq setuptools 'cirq-core[contrib]'

# The URL referenced earlier also advises the installation of packages outside
# of the Python runtime.  It was couched in terms of Debian-based package
# management, so I'll have to adapt this to RPM-based package names when I get
# around to it.
#
#sudo apt-get install texlive-latex-base latexmk

# Part of the old process that I had shelved.  On my first pass, I still kept
# using the virtualenv, until I realized that was no longer necessary.  If
# we're building an entire dedicated Python runtime just to host the modules we
# want to use, then virtualenv is redundant.
#
#${BIN}/pip3 install setuptools virtualenv
#${BIN}/virtualenv ${STUFF}/python-virtual-envs/cirq-runtime
#source ${STUFF}/python-virtual-envs/cirq-runtime/bin/activate
#pip install cirq
