#!/bin/bash
if [[ "$@" == "" ]] ; then
    gb -usage
    exit 1
fi

# function to make error output standard
error() {
    echo "gb: $1" >&2
}

#== parse if completion or execution {{{
executionMode=1
completionMode=2

runMode=$executionMode
if [[ "$1" == "@COMPLETION@" ]] ; then

    runMode=$completionMode
    shift
fi
#== }}}

if [ -z "$1" ] ; then
    error "No command passed" >&2
    exit 1
fi

cmd="$1"
shift
args="$@"

#== execute cmd {{{
for path in ${__gb_path//:/ }; do
    if [ -n "$path" ] && [ -f "$path/$cmd" ] ; then
        source "$path/$cmd"

        if [[ $runMode == $executionMode ]] ; then
            if type __run__ &> /dev/null ; then
                __run__ $args
                exit $?
            else
                error "command $cmd doesn't have a __run__ function"
                exit 1
            fi
        else
            if type __complete__ &> /dev/null ; then
                __complete__ $args
                exit $?
            else
                exit 1
            fi
        fi
    fi
done
error "command $cmd is not known"
exit 1

#== }}}
