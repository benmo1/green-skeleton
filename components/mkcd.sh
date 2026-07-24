#!/usr/bin/env bash

_bm_cds_file="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )/gen/cds.sh"
mkdir -p "$(dirname "${_bm_cds_file}")"
touch "${_bm_cds_file}"
. "${_bm_cds_file}"

# Make an alias to cd to the current directory
function mkcdalias () {
    local dirname="${PWD##*/}"
    local aliasname="cd${dirname}"
    local occurances
    occurances="$(grep -c "alias ${aliasname}=" "${_bm_cds_file}" 2>/dev/null || true)"
    if [[ "${occurances}" -gt 0 ]] ; then
        echo -e "Alias ${aliasname} already exists"'!'
    else
        echo -e "Alias ${aliasname} created"'!'
        echo "alias ${aliasname}='cd ${PWD}'" >> "${_bm_cds_file}"
        . "${_bm_cds_file}"
    fi

    return
}
