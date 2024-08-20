#!/usr/bin/env bash

set -xe

readonly sdk_dir=~/.transgui_sdk
readonly fpc_installdir="${sdk_dir}/fpc-3.2.4-rc1"
readonly fpc_basepath="${fpc_installdir}/lib/fpc/3.2.4"

mkdir -p "$sdk_dir"
cd "$sdk_dir"

curl -L -O https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
curl -L -O https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage
chmod +x linuxdeploy*

readonly fpc324_rc1_commit='d78e2897014a69f56a1cfb53c75335c4cc37ba0e'
curl -L -o fpc-src.tar.bz2 "https://gitlab.com/freepascal.org/fpc/source/-/archive/${fpc324_rc1_commit}/source-${fpc324_rc1_commit}.tar.bz2"
tar xf fpc-src.tar.bz2
mv "source-${fpc324_rc1_commit}" fpc-src
cd fpc-src

make all
mkdir -p "${fpc_installdir}"
make PREFIX=$fpc_installdir install
export PATH=${fpc_installdir}/bin:${fpc_basepath}:$PATH
fpcmkcfg -d basepath=${fpc_basepath} -o ~/.fpc.cfg

cd "$sdk_dir"
readonly lazarus_commit='4e69368d79e3801ad26a7bc7c1eda0ad3cf7dcc4'
curl -L -o lazarus-src.tar.bz2 "https://gitlab.com/dkk089/lazarus/-/archive/${lazarus_commit}/lazarus-${lazarus_commit}.tar.bz2"
tar xf lazarus-src.tar.bz2
mv "lazarus-${lazarus_commit}" lazarus
cd lazarus
make bigide LCL_PLATFORM=qt5

cd "$sdk_dir"
rm *.tar.bz2

cat - >> "${sdk_dir}/source.me" <<EOF
export PATH=${sdk_dir}/lazarus:${fpc_installdir}/bin:${fpc_basepath}:${sdk_dir}:\$PATH
export APPIMAGE_EXTRACT_AND_RUN=1
export TRANSGUI_LAZARUS_DIR=${sdk_dir}/lazarus
EOF
