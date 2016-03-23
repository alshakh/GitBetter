#!/usr/bin/env bash

### THIS FILE SHOULD BE INDEPENDENT FROM OTHER COMMANDS.
### This file execute things it can be dependent on itself
### For example it can't use 'gb ___resolve-cmd'.

if [[ "$@" == "" ]] ; then
    gb ??
    exit 1
fi

#= function to make output standard {{{
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
# turn a name to a file path. searches in path and then file
resolveCmd () {
    # if $1 starts with './' then just return it, because it's a file and not a command in path
    if [[ "$1" =~ ^\..* ]]; then
        echo "$1"
        return 0
    else
        for g_path in ${__gb_path//:/ }; do
                if [ -n "$g_path" ] && [ -e "$g_path/$1" ] && [ ! -d "$g_path/$1" ]  ; then
                    echo "$g_path/$1"
                    return 0
                fi
        done
        # if code reaches here, it's not found in __gb_path, return as is
        echo "$1"
        return 0
    fi
}
#= }}}

#= Parse $1 command name (define 'cmd' and 'SHOUTING' and then shift){{{
[ "$1" = "!" ] && {
    error "'!' is not a commands, append it to a command to make stronger"
    exit 1
}
SHOUTING=false
if echo "$1" | grep '!$' &> /dev/null ; then
    SHOUTING=true
fi
g_cmdName=$(echo "$1" | sed 's/!$//') # long prefix so it doesn't collide with the command file
shift
#= }}}

#= execute cmd {{{
g_cmdPath=$(resolveCmd $g_cmdName)
if [ -e $g_cmdPath ] ; then
    source "$g_cmdPath"
    if type __run__ &> /dev/null ; then
        __run__ "$@"
        exit $?
    else
        error "command '$g_cmdPath' doesn't have a '__run__' function"
        exit 1
    fi
else
    error "command $g_cmdName cannot be found"
    exit 1
fi
#= }}}
