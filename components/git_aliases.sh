#!/usr/bin/env bash

# Git
alias f='git fetch -p'
alias s='git status'
alias ds='git diff --staged'
alias co='git checkout'
alias b='git branch'
alias bb="git branch | grep \* | cut -d ' ' -f2" # print the current branch
alias lc="git rev-list HEAD -1 | pbcopy && pbpaste" # get full commit hash
alias lcs="git rev-list HEAD -1 | cut -c1-7 | pbcopy && pbpaste" # get 7 character commit hash for git hub

# Git push + set upstream branch if needed
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
        echo 'Please refine your search, more than one branch matched:'
        echo $branches | tr ' ' '\n'
    else
        git checkout $branches
    fi

    return
}

# Merge into current branch no fast forward
function m() {
    branches=`git branch -r | grep -v "origin/$(bb)" | awk '{$1=$1};1' | grep ${1-''}`;

    echo "Pick a branch to merge into this one:"
    select b in $branches; do
        if [ -n "$b" ] ; then
            break
        fi
    done

    echo 'Merging...'
    git merge --no-ff "$b"

    return
}
