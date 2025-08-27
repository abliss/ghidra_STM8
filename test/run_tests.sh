#!/bin/bash 
set -euxo pipefail

TEST_DIR="$(pwd)"
export TEST_DIR
for test in test_*.sh; do
    "./$test" || echo "test $test failed: $?"
done
