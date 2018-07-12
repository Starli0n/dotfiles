#echo .shell_zsh_sesu

# Backup DISPLAY variable in a file
echo export DISPLAY=$DISPLAY>~/.display

# Switch to root
sesu -c ~/.shell_zsh.sh -
