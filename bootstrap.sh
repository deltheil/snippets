#!/bin/bash
set -e

git submodule update --init fakeredis.c
pushd fakeredis.c >/dev/null
git submodule update --init
make -f ios.mk
popd >/dev/null
pushd client/Snippets >/dev/null
pod install
popd >/dev/null
echo "Done."
