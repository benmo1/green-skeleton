#!/usr/bin/env bash

# convenience variables

export TEST_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )
export ROOT_DIR="$TEST_DIR"/../
export TEMP_DIR="$TEST_DIR"/temp/

cd "$TEST_DIR" # default paths in test suite relative to test root

tests=`find ./suites/ -name *_test.sh`

status=0
for t in $tests ; do
    "$TEST_DIR"/lib/shunit2 $t
    if [ $? != 0 ] ; then
        status=code
    fi
done

exit $status
