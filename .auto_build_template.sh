#!/usr/bin/env bash

##GIT_ROOT##

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )

LIMIT="$DIR"/.auto_update_limit
LAST="$DIR"/.auto_update_limit

touch "$LIMIT"
touch -A-0010 "$LIMIT" # max once every 10 seconds

if [ "$LIMIT" -nt "$LAST" ]; then
    (
        cd "$GIT_ROOT"
        response=`git fetch`
        if [[ -n $response ]] ; then
            ./build.sh
        fi
    ) &

    touch "$LAST"
fi

rm "$LIMIT"
