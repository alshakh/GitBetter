#!/bin/bash

#= Check if git is installed {{{
( git --version 2>&1 >/dev/null ) || {
    echo "gb: git is not installed" >&2
    return 1
}
#= }}}

#= Export gb needed variables and functions {{{
export __gb_dir="$( dirname ${BASH_SOURCE[0]} )"
export __gb_path="$__gb_dir/gb-cmds:$__gb_dir/cmds"
#= }}}

#= Completion {{{
__gb_completion() {
    COMPREPLY=()
    local result
    result="$(gb ___complete ^${COMP_WORDS[COMP_CWORD]} ${COMP_WORDS[@]:1:COMP_CWORD-1})"
    if (( $? == 0 )) ; then
        COMPREPLY=( ${result[@]} )
    else
        COMPREPLY=( $(compgen -f -- ${COMP_WORDS[COMP_CWORD]}) )
    fi
    return 0
}
complete -F __gb_completion gb
#= }}}
