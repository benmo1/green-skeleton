#!/usr/bin/env bash

# convenience variables

export ROOT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )
export TEMP_DIR=/tmp/gs_test/

tests=`find ./tests/ -name *_test.sh`

status=0
for t in $tests ; do
    "$ROOT_DIR"/lib/shunit2 $t
    if [ $? != 0 ] ; then
        status=1
    fi
done

exit $status
