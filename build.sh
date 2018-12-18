#!/usr/bin/env bash

# locate this script

COMPONENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"/components

# helper function

function append_onto_bashrc_once() {
    match=`grep ". $1" ~/.bashrc`
    if [[ -z $match ]] ; then
        echo ". $1" >> ~/.bashrc
    fi
}

# make sure relevant bash files / folders are present

if ! [[ -e ~/.bash_profile ]] ; then
    echo 'Creating blank ~/.bash_profile ...'
    touch ~/.bash_profile
fi

if ! [[ -e ~/.bashrc ]] ; then
    echo 'Creating blank ~/.bashrc ...'
    touch ~/.bashrc
fi

if ! [[ -e ~/.bm_bash ]] ; then
    mkdir ~/.bm_bash
fi

match=`grep bashrc ~/.bash_profile`

if [[ -z $match ]] ; then
    echo 'Sourcing ~/.bashrc in ~/.bash_profile ...'
    echo '. ~/.bashrc' >> ~/.bash_profile
fi

# install components

components=`ls "$COMPONENT_DIR"`

for file in $components ;
do
    destination=~/.bm_bash/"$file"
    cp "$COMPONENT_DIR"/"$file" "$destination"
    if [[ $file != "header.sh" ]] ; then
        append_onto_bashrc_once $destination
    fi
done

. ~/.bashrc
