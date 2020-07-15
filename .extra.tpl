### .extra is called in .starrc after export variables but before aliases

${PY3}alias python=python3 # Uncomment if python3 is installed

# Add export variables here...
export SRC_DIR="${SRC_DIR}"
export WORK="${WORK}"

extra-callback () { # Called after aliases in .starrc

    # Add aliases here...
    alias gguser='git config --global user.name Starli0n; git config --global user.email Starli0n@users.noreply.github.com'
    alias guser='git config user.name Starli0n; git config user.email Starli0n@users.noreply.github.com'

}
