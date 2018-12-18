#!/usr/bin/env bash

config_file=~/.ssh/config

# ssh by grepping the default config file
function +ssh () {
    if ! [[ -f $config_file ]] ; then
        echo "$config_file not found!"
        return
    fi

    hosts=`egrep '^\s*\bHost\b\s+(\w+)\s*$' $config_file | awk '{$1=$1}1' | cut -d' ' -f2 | grep ${1-''}`

    if [[ -z $hosts ]] ; then
        echo "No hosts in $config_file!"
        return
    fi

    echo 'Where would you like to go?'
    select h in $hosts; do
        if [ -n "$h" ] ; then
            break
        fi
    done

    ssh "$h"
}
