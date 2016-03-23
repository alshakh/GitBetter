#!/usr/bin/env bash
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
for g_path in ${__gb_path//:/ }; do
    if [ -n "$g_path" ] && [ -f "$g_path/$g_cmdName" ] ; then

        source "$g_path/$g_cmdName"
        if type __run__ &> /dev/null ; then
            __run__ "$@"
            exit $?
        else
            error "command '$g_cmdName' doesn't have a '__run__' function"
            exit 1
        fi

    fi
done
error "command '$g_cmdName' is not known"
exit 1
#= }}}
