#!/usr/bin/env bash

# Coloured ssh
function cssh () {
    PROFILE="Basic" # Profile name while sshed
    DEFAULT="Pro" # Default profile name
    echo "tell app \"Terminal\" to set current settings of first window to settings set \"${PROFILE}\"" | osascript
    ssh $1 $2
    echo "tell app \"Terminal\" to set current settings of first window to settings set \"${DEFAULT}\"" | osascript
}
