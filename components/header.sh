#!/usr/bin/env bash

if [[ -n $has_run ]] ; then
    return
fi

function is_mac () {
    [[ `uname -s` == 'Darwin' ]]
}

has_run=1;
