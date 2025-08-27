#!/bin/bash 
set -euxo pipefail
if [ -z "$GHIDRA_HOME" ]; then
    echo "Please set GHIDRA_HOME"
fi

rm -rf testProject.rep testProject.gpr
sdcc -mstm8 jpx0.c --out-fmt-elf
time \
    #strace -o strace.txt -f -s4096 \
    analyzeHeadless $(pwd) testProject -import jpx0.elf  -processor "STM8:BE:16:default" \
    -scriptPath "$(pwd)" -postScript     'DecompileHeadless.java'     #'decompile.py' 


