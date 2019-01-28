#!/usr/bin/env bash

DIST_COMPONENT_DIR="$TEMP_DIR"/.bm_bash/
DIST_PROFILE="$TEMP_DIR"/.bash_profile
DIST_RC="$TEMP_DIR"/.bashrc

testBuild() {
    . "$ROOT_DIR"/build.sh "$TEMP_DIR" "$ROOT_DIR"/components/
}

setup() {
    rm -rf $TEMP_DIR/ # rm -rf dir/* does not remove hidden files
    mkdir $TEMP_DIR/
}

tearDown() {
    rm -rf $TEMP_DIR/ # rm -rf dir/* does not remove hidden files
    mkdir $TEMP_DIR/
}

testBuildCreatesExpectedFiles() {
    testBuild

    assertTrue '.bash_profile was created' "[ -f $DIST_PROFILE ]"
    assertTrue '.bashrc was created' "[ -f $DIST_PROFILE ]"
    assertTrue '.bm_bash/ was created' "[ -d $DIST_COMPONENT_DIR ]"
    components=`ls -R "$ROOT_DIR"/components/`
    dist_components=`ls -R "$DIST_COMPONENT_DIR"`
    assertEquals 'components were created' "$components" "$dist_components"
}

testBuildReferencesAllDistComponentsInBashRc() {
    testBuild

    dist_components=`find "$DIST_COMPONENT_DIR" -type f -exec basename {} \; | grep -v 'header.sh'` # file names with no paths
    echo $dist_components
    cat $DIST_RC
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
    content_before='TEST CONTENTS'
    profile="$TEMP_DIR"/.bash_profile
    echo "$content_before" >> "$profile"

    testBuild

    content_after=`cat "$profile"`
    assertContains '.bash_profile was not overwritten' "$content_after" "$content_before"
}

testBuildDoesNotChangeExistingBashRcContent() {
    content_before='TEST CONTENTS'
    rc="$TEMP_DIR"/.bashrc
    echo "$content_before" >> "$rc"

    testBuild

    content_after=`cat "$rc"`
    assertContains '.bashrc was not overwritten' "$content_after" "$content_before"
}

testBuildIsIdempotent() {
    testBuild
    before=`find "$TEMP_DIR" -type f -exec md5 {} \; | sort -k 2 | md5` # directory fingerprint
    testBuild
    after=`find "$TEMP_DIR" -type f -exec md5 {} \; | sort -k 2 | md5` # directory fingerprint

    assertEquals 'The build results in the same components when run twice' "$before" "$after"
}
