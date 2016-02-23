#!/bin/bash

#= Check if git is installed {{{
( git --version 2>&1 >/dev/null ) || {
    echo "gb: git is not installed" >&2
    return 1
}
#= }}}

#= Export gb needed variables and functions {{{
export __gb_dir="$( dirname ${BASH_SOURCE[0]} )"
export __gb_path="$__gb_dir/cmds"
#= }}}

#= Define gl command {{{
source "${__gb_dir}/gb-completion.sh"
complete -F __gb_completion gb
#= }}}
