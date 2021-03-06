#echo .shell_zsh

if [[ "$(whoami)" == "root" ]]; then
    # Change HOME
    export HOME=$(cd "$(dirname "$0")"; pwd)
    cd

    # Load DISPLAY variable from
    if [ -f ~/.display ]; then
        . ~/.display
    fi
fi

if [[ -z "$@" ]]; then
    /bin/zsh
else
    /bin/zsh -c "$@"
fi
