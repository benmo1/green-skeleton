#!/usr/bin/env bash

if [[ `uname -s` == 'Linux' ]] ; then
    md5tool='md5sum'
elif [[ `uname -s` == 'Darwin' ]] ; then
    md5tool='md5'
fi

DIST_COMPONENT_DIR="$TEMP_DIR"/.bm_bash/
DIST_PROFILE="$TEMP_DIR"/.bash_profile
DIST_RC="$TEMP_DIR"/.bashrc

runBuildScript() {
    . "$ROOT_DIR"/build.sh 0 "$TEMP_DIR" "$ROOT_DIR"/components/ 1>/dev/null
}

setUp() {
    rm -rf $TEMP_DIR/ # rm -rf dir/* does not remove hidden files
    mkdir $TEMP_DIR/
}

tearDown() {
    rm -rf $TEMP_DIR/ # rm -rf dir/* does not remove hidden files
    mkdir $TEMP_DIR/
}

testBuildCreatesExpectedFiles() {
    runBuildScript

    assertTrue '.bash_profile was created' "[ -f $DIST_PROFILE ]"
    assertTrue '.bashrc was created' "[ -f $DIST_PROFILE ]"
    assertTrue '.bm_bash/ was created' "[ -d $DIST_COMPONENT_DIR ]"

    component_diff=`diff $ROOT_DIR/components/ $DIST_COMPONENT_DIR/`
    assertTrue 'The components have been created' '[ -z "$component_diff" ]'
}

testBuildReferencesAllDistComponentsInBashRc() {
    runBuildScript

    dist_components=`find "$DIST_COMPONENT_DIR" -type f -exec basename {} \; | grep -v 'header.sh'` # file names with no paths

    miss=0
    for c in $dist_components
    do
        if [[ -z `grep "$c" "$DIST_RC"` ]] ; then
            miss=1
        fi
    done

    assertEquals 'All dist components were referenced in the dist .bashrc' 0 $miss
}

testBuildDoesNotChangeExistingBashProfileContent() {
    content_before='alias foo="echo 1"'
    profile="$TEMP_DIR"/.bash_profile
    echo "$content_before" >> "$profile"

    runBuildScript

    content_after=`cat "$profile"`
    assertContains '.bash_profile was not overwritten' "$content_after" "$content_before"
}

testBuildDoesNotChangeExistingBashRcContent() {
    content_before='alias foo="echo 1"'
    rc="$TEMP_DIR"/.bashrc
    echo "$content_before" >> "$rc"

    runBuildScript

    content_after=`cat "$rc"`
    assertContains '.bashrc was not overwritten' "$content_after" "$content_before"
}

testBuildIsIdempotent() {
    runBuildScript
    before=`find "$TEMP_DIR" -type f -exec $md5tool {} \; | sort -k 2 | $md5tool` # directory fingerprint
    runBuildScript
    after=`find "$TEMP_DIR" -type f -exec $md5tool {} \; | sort -k 2 | $md5tool` # directory fingerprint

    assertEquals 'The build results in the same components when run twice' "$before" "$after"
}
