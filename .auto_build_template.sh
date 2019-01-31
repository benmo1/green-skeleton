#!/usr/bin/env bash

##GIT_ROOT##

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )

LIMIT="$DIR"/.auto_update_limit
LAST="$DIR"/.auto_update_last

touch "$LIMIT"
touch -A-0010 "$LIMIT" # max once every 10 seconds

if [ "$LIMIT" -nt "$LAST" ]; then
    (
        cd "$GIT_ROOT"
        before=`git rev-parse HEAD`
        git pull
        after=`git rev-parse HEAD`
        if [[ $after != $before ]] ; then
            ./build.sh
        fi
    ) >/dev/null 2>&1

    touch "$LAST"
fi

rm "$LIMIT"
