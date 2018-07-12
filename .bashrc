#echo .bashrc

if [ -f ~/.starrc ]; then
    . ~/.starrc
fi

# default: export PS1="[\u@\h \W]\$"
export PS1="\n$BLUE\u$CYAN@$MAGENTA\h $GREEN\w $RED\$(git branch 2> /dev/null)\n${YELLOW}λ $NORMAL"

# Make completion with `m`
complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" m
