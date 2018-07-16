#!/bin/sh

if [ "$#" -eq 0 ] ; then
	exit

# Shell Git
elif [ "$1" = "shell" ] ; then
	$2 $3 $4 $5 $6 $7 $8 $9

# Diff Tool
elif [ "$1" = "difftool" ] && [ "$#" -eq 4 ] ; then
	if [ "$2" = "/dev/null" ] ; then
		echo FileN : $3
	elif [ "$3" = "/dev/null" ] ; then
		echo FileD : $2
	else
		if [ "$4" = "local" ] ; then
			CAPTION=Local
		else
			CAPTION=Staged
		fi
		echo Comparing...
		echo "   Left : $2"
		echo "  Right : $3"
		echo
		if [ "$OS_TYPE" == "Linux" ]; then
			"bcomp" -title1="Base - $2" -title2="$CAPTION - $3" "$2" "$3"
		else
			"$WINMERGE_BIN" -e -u -dl "Base - $2" -dr "$CAPTION - $3" "$2" "$3"
		fi
	fi

# Sublime Text: add modified files
elif [ "$1" = "sublime" ] && [ "$#" -eq 3 ] ; then
	if [ "$2" = "/dev/null" ] ; then
		echo New : $3
		subl -a "$3"
	elif [ "$3" = "/dev/null" ] ; then
		echo FileD : $2
	else
		echo Mod : $3
		subl -a "$3"
	fi

# Merge Tool
elif [ "$1" = "mergetool" ] && [ "$#" -eq 5 ] ; then
	echo Launching Merge tool
	echo LOCAL_ : $2
	echo REMOTE : $3
	echo BASE__ : $4
	echo MERGED : $5
	"bcomp" "$2" "$3" "$4" "$5"

# Log Feature
elif [ "$1" = "logfeature" ] && [ "$#" -eq 2 ] ; then
	PARENT=`git rev-parse --short "$2^2"`
	if [ "$?" -eq 0 ]; then
		git ll $PARENT
	else
		echo "(No 2nd parent found for this commit)"
	fi

fi
