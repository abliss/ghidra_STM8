#!/bin/bash 
set -euxo pipefail

# if GHIDRA_HOME is set, use it; otherwise set one up
if [ -z "$GHIDRA_HOME" ]; then
    export GHIDRA_HOME="$TMPDIR/ghidra_STM8_tests/ghidra_home"
fi

analyzeHeadless="$GHIDRA_HOME/support/analyzeHeadless"

# if analyzeHeadless exists, use it; otherwise we need to install ghidra
if [ ! -e "$analyzeHeadless" ]; then
    # first download the zip if it isn't there already
    ghidra_zip="$TMPDIR/ghidra.zip"
    ghidra_url="https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.4.2_build/ghidra_11.4.2_PUBLIC_20250826.zip"
    if [ ! -e "ghidra_zip" ]; then
        curl -v -L -H- "$ghidra_url" -o "$ghidra_zip" |& grep -v "Supplemental data" |& grep -v " bytes data"
    fi

    mkdir -p "$GHIDRA_HOME";
    cd "$GHIDRA_HOME";
    unzip "$ghidra_zip";
    # the ghidra zip file adds an extra directory layer; remove it
    extra_dir=*
    (shopt -s dotglob; mv "$extra_dir/*") 
    rmdir "$extra_dir"
fi

# ensure sdcc enabled
if ! which sdcc; then
    sudo apt install -y sdcc
fi


export TEST_DIR=$(pwd)
for test in test_*.sh; do
    "./$test" || echo "test $test failed: $?"
done
