#!/usr/bin/env bash
set -e
# Envs
export CFLAGS="-I$(brew --prefix)/include $CFLAGS"
export LDFLAGS="-L$(brew --prefix)/lib $LDFLAGS"
export LIBRARY_PATH="$(brew --prefix)/lib:$LIBRARY_PATH"

pushd yari-sys/yara
./bootstrap.sh
CFLAGS="-fPIC $CFLAGS" ./configure --enable-debug --disable-shared --enable-static --enable-magic --enable-dotnet --with-crypto --enable-cuckoo
make clean && make
popd

pushd yari-sys
cargo build -r
popd

pushd yari-cli
cargo build -r
popd

pushd yari-py
maturin build -i python3.11 -i python3.12
popd
