#!/usr/bin/env bash

oneTimeSetup() {
    rm -rf ./tests/temp/*
}

oneTimeTearDown() {
    rm -rf ./tests/temp/*
}

testBuildCreatesExpectedFiles() {
    . ../build.sh ./temp/ ../components/
    assertTrue '.bash_profile was created' '[ -f ./temp/.bash_profile ]'
    assertTrue '.bashrc was created' '[ -f ./temp/.bashrc ]'
    assertTrue '.bm_bash/ was created' '[ -d ./temp/.bm_bash/ ]'
    components=`ls $ROOT_DIR/components/`
    dist=`ls $TEMP_DIR/.bm_bash/`
    assertEquals 'components were created' "$components" "$dist"
}
