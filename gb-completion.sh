#!/usr/bin/env bash

__gb_completion() {

    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"

    COMPREPLY=()
    if [[ $COMP_CWORD == 1 ]] ; then
        local cmdList=""
        for path in ${__gb_path//:/ }; do
            cmdList="$cmdList $(find $path | sed 's@.*/@@')"
        done
        #
        COMPREPLY=( $(compgen -W "${cmdList}" -- ${cur}) )
    elif (( $COMP_CWORD >= 2 )) ; then
        # call `gb @COMPLETION@ finished-arguments ^cur`
        local result
        result="$(gb @COMPLETION@ ${COMP_WORDS[1]} ${COMP_WORDS[@]:2:$COMP_CWORD-2} ^$cur)"
        if (( $? == 0 )) ; then
            COMPREPLY=( ${result[@]} )
        else
            COMPREPLY=( $(compgen -f -- ${cur}) )
        fi
    fi
    return 0
}
