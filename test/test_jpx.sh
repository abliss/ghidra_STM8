#!/bin/bash 
set -euxo pipefail

rm -rf testProject.rep testProject.gpr

sdcc -mstm8 jpx0.c --out-fmt-elf
analyzeHeadless="$GHIDRA_HOME/support/analyzeHeadless"

analyzeHeadless "$TEST_DIR" testProject -import jpx0.elf  -processor "STM8:BE:16:default" \
                -scriptPath "$TEST_DIR" -postScript     'DecompileHeadless.java'



