#!/usr/bin/env sh
set -eu

CRYSTAL=${CRYSTAL:-../.build/crystal}

mkdir -p build

build_lib() {
  name="$1"
  "$CRYSTAL" build "$name.cr" \
    -Dwithout_main \
    --single-module \
    --link-flags="-shared -Wl,--version-script=$PWD/exports/$name.exports" \
    -o "build/lib$name.so"
}

export CRYSTAL_PATH=../src
export CRYSTAL_CACHE_DIR=/tmp/crystal-cache

build_lib alpha
build_lib beta
build_lib gamma

printf 'Built shared libraries in build\n'
nm -D --defined-only build/libalpha.so
nm -D --defined-only build/libbeta.so
nm -D --defined-only build/libgamma.so
