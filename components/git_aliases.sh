#!/usr/bin/env bash

# Git
alias s='git status'
alias ds='git diff --staged'
alias co='git checkout'
alias bb="git branch | grep \* | cut -d ' ' -f2" # print the current branch
alias lc="git log -1 --format='%h' | pbcopy && pbpaste" # get length 7 commit hash for github

function p () {
    output=$(git push "$@" 2>&1)
    echo "$output" # for user info
    match=`echo "$output" | grep -c 'The current branch .* has no upstream branch'`
    if [[ $match -eq 1 ]] ; then
        echo 'Found no upstream branch warning, trying to create upstream...'
        `echo $output | grep -oh 'use .*$' | cut -c5-`
    fi

    return
}

# Checkout branch by regex
function go () {
    branches=`git branch -r | awk '{$1=$1};1' | sed 's/^origin\///' | grep $1`;

    if [[ -z $branches ]] ; then
        echo 'No branches matched.'
        return
    fi

    count=`echo $branches | tr ' ' '\n' | wc -l`;

    if [[ $count -gt 1 ]] ; then
        echo 'Please refine your search, more than one branch matched: '
        echo $branches | tr ' ' '\n'
    else
        git checkout $branches
    fi

    return
}
