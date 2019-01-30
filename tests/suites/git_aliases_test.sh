#!/usr/bin/env bash

(
    status=`git --version && echo $?`
    if [ "$status" != 0 ] ; then
        yum install git -y
        git config --global user.email "test@test.com"
        git config --global user.name "Test Name"
    fi
) >/dev/null 2>&1

LOCAL_REPO="$TEMP_DIR"/local/
REMOTE_REPO="$TEMP_DIR"/remote/

. "$ROOT_DIR"/components/git_aliases.sh

setUp() {
    (
        rm -rf "$TEMP_DIR" # rm -rf dir/* does not remove hidden files
        mkdir "$TEMP_DIR"
        mkdir "$REMOTE_REPO"
        (cd "$REMOTE_REPO" &&
                  git init &&
           touch README.md &&
                 git add . && git commit -m 'Initial Commit')
        git clone "$REMOTE_REPO"/.git "$LOCAL_REPO"
    ) >/dev/null 2>&1
}

tearDown() {
    rm -rf "$TEMP_DIR" # rm -rf dir/* does not remove hidden files
}

testPCreatesUpstream() {
    (
        cd "$LOCAL_REPO"
        git checkout -b new-branch
        p

        status=`git rev-parse @{u} 1>/dev/null 2>&1 && echo $?`
        assertEquals 'Branch upstream was set' 0 $status
    ) >/dev/null 2>&1 # git seems to write to stderr during normal operation, stop test spamming (1)
}

testPPushesCommit() {
    (
        cd "$LOCAL_REPO"
        git checkout -b new-branch
        touch a_file.txt
        git add .
        git commit -m 'Add a file'
        p

        local_hash=`git rev-parse HEAD`
        remote_hash=`git rev-parse @{u} 2>/dev/null`
        assertEquals 'Commit was pushed to remote' "$local_hash" "$remote_hash"
    ) >/dev/null 2>&1 # (see 1)
}

testPPushesCommitWithExistingRemote() {
    (
        cd "$LOCAL_REPO"
        git checkout -b new-branch
        p

        touch a_file.txt
        git add .
        git commit -m 'Add a file'
        p

        local_hash=`git rev-parse HEAD`
        remote_hash=`git rev-parse @{u} 2>/dev/null`
        assertEquals 'Commit was pushed to remote' "$local_hash" "$remote_hash"
    ) >/dev/null 2>&1 # (see 1)
}