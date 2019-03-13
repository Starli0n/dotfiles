#echo .bashrc

if [ -f ~/.starrc ]; then
    . ~/.starrc
fi

# Define PS1 prompt for bash
if [[ "$MSYSTEM" == "MINGW64" ]]; then
	# default MINGW64
	# export PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]\n\[\033[32m\]\u@\h \[\033[35m\]$MSYSTEM \[\033[33m\]\w\[\033[36m\]`__git_ps1`\[\033[0m\]\n$ '
	function __status_ps1 ()
	{
		if [ $? -eq 0 ]; then # Status OK = Green
			echo $GREEN
		else # Status KO = Red
			echo $RED
		fi
	}
	export PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]\n${RED}\u${BLUE}@${GREEN}\h ${MAGENTA}$MSYSTEM ${YELLOW}$PWD${CYAN}`__git_ps1``__status_ps1`\nλ ${NORMAL}'
else
	# default: export PS1="[\u@\h \W]\$"
	export PS1="\n$BLUE\u$CYAN@$MAGENTA\h $GREEN\w $RED\$(git branch 2> /dev/null)\n${YELLOW}λ $NORMAL"
fi

# Make completion with `m`
complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" m
