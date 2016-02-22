#!/bin/bash
if [[ "$@" == "" ]] ; then
    gb -usage
    exit 1
fi

# function to make output standard
error() {
    echo "gb: $1" >&2
}
startColor() {
    if [ "$1" == "RED" ] ; then
        printf "\e[91m"
    elif [ "$1" == "BLUE" ] ; then
        printf "\e[34m"
    elif [ "$1" == "GREY" ] ; then
        printf "\e[90m"
    elif [ "$1" == "GREEN" ] ; then
        printf "\e[32m"
    elif [ "$1" == "YELLOW" ] ; then
        printf "\e[33m"
    else
        printf "\e[39m"
    fi
}
endColor() {
    printf "\e[0m"
}
color() {
    startColor $1
    shift
    printf "$*"
    endColor
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

cmdExclimation=""
if echo "$1" | grep '!$' &> /dev/null ; then
    cmdExclimation="!"
fi
cmd=$(echo "$1" | sed 's/!$//')
shift

#== execute cmd {{{
for path in ${__gb_path//:/ }; do
    if [ -n "$path" ] && [ -f "$path/$cmd" ] ; then
        source "$path/$cmd"

        if [[ $runMode == $executionMode ]] ; then
            if type __run__ &> /dev/null ; then
                __run__  $cmdExclimation "$@"
                exit $?
            else
                error "command $cmd doesn't have a __run__ function"
                exit 1
            fi
        else
            if type __complete__ &> /dev/null ; then
                __complete__ "$@"
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
