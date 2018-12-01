#!/usr/bin/env bash

# General
alias bvim='vim ~/.bashrc && . ~/.bashrc'
alias hvim='vim /etc/hosts'
alias svim='vim ~/.ssh/config'

# Make an alias to cd to the current directory
function mkcdalias () {
    dirname=`pwd | egrep -oh '[^\/\0]+$'`
    aliasname="cd$dirname"
    occurances=`grep -c "alias $aliasname" ~/.bashrc`
    if [[ $occurances -gt "0" ]] ; then
        echo -e "Alias $aliasname already exists"'!'
    else
        echo -e "Alias $aliasname created"'!'
        echo "alias $aliasname='cd $PWD'" >> ~/.bashrc
        . ~/.bashrc
    fi

    return
}
