#!/usr/bin/env bash

# inputs / defaults

BUILD_DIR=${1:-~}
COMPONENT_DIR=${2:-./components}
AUTO_BUILD=1

# helper functions

function append_onto_bashrc_once() {
    match=`grep ". $1" "$BUILD_DIR"/.bashrc`
    if [[ -z $match ]] ; then
        echo ". $1" >> "$BUILD_DIR"/.bashrc
    fi
}

# make sure relevant bash files / folders are present

if ! [[ -e "$BUILD_DIR"/.bash_profile ]] ; then
    echo "Creating blank $BUILD_DIR/.bash_profile ..."
    touch "$BUILD_DIR"/.bash_profile
fi

if ! [[ -e "$BUILD_DIR"/.bashrc ]] ; then
    echo "Creating blank $BUILD_DIR/.bashrc ..."
    touch "$BUILD_DIR"/.bashrc
fi

if ! [[ -e "$BUILD_DIR"/.bm_bash ]] ; then
    mkdir "$BUILD_DIR"/.bm_bash
fi

match=`grep bashrc "$BUILD_DIR"/.bash_profile`

if [[ -z $match ]] ; then
    echo "Sourcing $BUILD_DIR/.bashrc in $BUILD_DIR/.bash_profile ..."
    echo ". $BUILD_DIR/.bashrc" >> "$BUILD_DIR"/.bash_profile
fi

# install components

components=`ls "$COMPONENT_DIR"`

for file in $components ;
do
    destination="$BUILD_DIR"/.bm_bash/"$file"
    cp "$COMPONENT_DIR"/"$file" "$destination"

    if [[ $file == 'header.sh' ]] ; then
        continue
    fi

    append_onto_bashrc_once $destination
done

# install optional auto build

function append__auto_onto_bashrc_once() {
    match=`grep "$1" "$BUILD_DIR"/.bashrc`
    if [[ -z $match ]] ; then
        echo "(bash $1 &)" >> "$BUILD_DIR"/.bashrc
    fi
}

if [[ $AUTO_BUILD == 1 ]] ; then
    destination="$BUILD_DIR"/.bm_bash/.auto_build.sh
    DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )
    cp "$DIR"/.auto_build_template.sh "$destination"
    sed -i '.bak' "s|^##GIT_ROOT##$|GIT_ROOT=$DIR|g" "$destination"
    append_auto_onto_bashrc_once "$destination"
fi

. "$BUILD_DIR"/.bashrc
