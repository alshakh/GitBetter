#!/bin/bash

__gb_completion() {

    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"

    COMPREPLY=()
    if [[ $COMP_CWORD == 1 ]] ; then
        local cmdList=""
        for path in ${__gb_path//:/ }; do
            cmdList="$cmdList"" "$(find $path -type f -printf "%f\n")
        done
        #
        COMPREPLY=( $(compgen -W "${cmdList}" -- ${cur}) )
    elif (( $COMP_CWORD >= 2 )) ; then
        # Define function to get completion lists
        
        # call `gb @COMPLETION@ finished-arguments` and not cur
        local possibilities
        possibilities="$(gb @COMPLETION@ ${COMP_WORDS[1]} ${COMP_WORDS[@]:2:$COMP_CWORD-2})"
        if (( $? == 0 )) ; then
            COMPREPLY=( $(compgen -W "${possibilities}" -- ${cur}) )
        else
            COMPREPLY=( $(compgen -f -- ${cur}) )
        fi
    fi
    return 0
}
