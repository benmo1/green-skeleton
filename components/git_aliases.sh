#!/usr/bin/env bash

. $( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )/header.sh

GIT_HIST_DIR=~
GIT_HIST_FILE=.gs_git_hist # Location to store recent branch checkouts
GIT_HIST_SHOW=7 # Number of recently checked out branches to show

if ! [[ -d GIT_HIST_DIR ]] ; then
    mkdir -p $GIT_HIST_DIR;
fi

# Git
alias f='git fetch -p'
alias s='git status'
alias ds='git diff --staged'
alias b='git branch'
alias bb="git branch | grep \* | cut -d ' ' -f2" # print the current branch
alias lc="git rev-list HEAD -1 | pbcopy && pbpaste" # get full commit hash
alias lcs="git rev-list HEAD -1 | cut -c1-7 | pbcopy && pbpaste" # get 7 character commit hash for git hub
alias pl="git pull"
alias nearest_git_repo="git rev-parse --show-toplevel"

# Git push + set upstream branch if needed
function p () {
    output=$(git push "$@" 2>&1)
    echo "$output" # for user info
    match=`echo "$output" | grep -c '\--set-upstream'`
    if [[ $match -eq 1 ]] ; then
        echo 'Found no upstream branch warning, trying to create upstream...';
        push_with_upstream_command=`git push "$@" 2>&1 | grep -oh 'git push .*$'`;
        $push_with_upstream_command
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

# Track branch changes when doing git checkout
# This enables ghist to show recently checkout branches
function co() {
    checkout_line=`git checkout $* 2>&1 | egrep "Switched to.*branch.*'.*'"`; # first * caters for new branches
    branch=`echo ${checkout_line##*' '} | cut -d"'" -f2`; # last item on the line, remove the enclosing quotes
    git_repo=`nearest_git_repo`;
    echo "$git_repo $branch" >> $GIT_HIST_DIR/$GIT_HIST_FILE;
}

# Show recently checkout out branches
function ghist() {
    git_repo=`nearest_git_repo`;
    tail -n150 $GIT_HIST_DIR/$GIT_HIST_FILE |
                           grep "$git_repo" |
                             cut -d' ' -f 2 |
                             awk '!x[$0]++' | # This removes duplicates without sorting
                      tail -rn$GIT_HIST_SHOW;
}

# Recent tags
function rt() {
    echo ""
    git log --pretty='format:%h %C(yellow)%<(12,trunc)%(describe:tags=true) %C(white)%s' -20 --grep="into 'master'" --reverse;
    echo ""
    echo "Currently on:"
    git log --pretty='format:%h %C(yellow)%<(12,trunc)%(describe:tags=true) %C(white)%s' -1;
}

# Tag and push
gt()
{
  if [[ -z "$1" || -z "$2" ]]
  then
    echo "Please supply a tag name and a commit hash eg: 'gt_rename v1.0.1 A907F2B";
    exit 1;
  fi

  if git rev-parse "$TAG" >/dev/null 2>&1
  then
    echo "Deleting tag:";
    git tag -d "$1";
    git push origin :"$1";
  fi

  echo "Recreating tag:";
  git tag "$1" "$2";
  git push origin "$1"
}

alias grh="git reset HEAD --hard"
