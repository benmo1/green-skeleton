#!/usr/bin/env bash

. $( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )/header.sh

config_file=~/.ssh/config

# ssh by grepping the default config file
function +ssh () {
    if ! [[ -f $config_file ]] ; then
        echo "$config_file not found!"
        return
    fi

    hosts=`egrep '^\s*\bHost\b\s+.*$' $config_file | awk '{$1=$1}1' | cut -d' ' -f 2- | grep ${1-''}`

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

    if [[ -n `declare -f cssh` ]] ; then
        cssh "$h"
    else
        ssh "$h"
    fi
}

if is_mac ; then
    # Coloured ssh
    function cssh () {
        PROFILE="Basic" # Profile name while sshed
        DEFAULT="Pro" # Default profile name
        echo "tell app \"Terminal\" to set current settings of first window to settings set \"${PROFILE}\"" | osascript
        ssh $1 $2
        echo "tell app \"Terminal\" to set current settings of first window to settings set \"${DEFAULT}\"" | osascript
    }
fi
