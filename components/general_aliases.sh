#!/usr/bin/env bash

. $( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )/header.sh

# General
alias bvim='vim ~/.bashrc && . ~/.bashrc'
alias hvim='sudo vim /etc/hosts'
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

# Decrypt the contents of your clip board with gpg
function gpg_d_clip() {
    pbpaste > temp.gpg
    gpg -d temp.gpg
    rm -P temp.gpg
}

function gpg_i_clip() {
   pbpaste > temp.key
   gpg --import temp.key
   rm -P temp.key
}
