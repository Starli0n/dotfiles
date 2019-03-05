# dotfiles
My dotfiles compatible with `bash` and `zsh`

## Introduction

Logic behind bash dotfiles, from this example, `.bashrc` has to be sourced from `.bash_profile`
```sh
> ssh Starli0n@localhost
> .bash_profile

> /bin/bash
> .bashrc
```

Following this logic, I created a `.starrc` dotfile which is sourced from `.bashrc` or `.zshhrc` so that environment is shared with both.

The `.bash_profile` dotfile only includes `.profile` and `.bashrc`.

The `.profile` dotfile does nothing specific but I prefer to keep it into source control in case an installer changes it.


## Installation

After installing [Oh My ZSH!](https://ohmyz.sh)

```sh
ln -s $HOME/.starli0n.zsh-theme .oh-my-zsh/themes/starli0n.zsh-theme
```

Add some specific into the `.extra` dotfile like proxy etc...
```sh
root(){
    if [ -f $HOME/.shell_zsh_sesu.sh ]; then
        source $HOME/.shell_zsh_sesu.sh
    fi
}

proxy () {
	echo -n "Login:"
	read -s PROXY_USER
	echo
	echo -n "Password:"
	read -s PROXY_PASS
	echo
	export http_proxy=http://$PROXY_USER:$PROXY_PASS@proxy-url:8080
	export https_proxy=http://$PROXY_USER:$PROXY_PASS@proxy-url:8080
	export HTTP_PROXY=http://$PROXY_USER:$PROXY_PASS@proxy-url:8080
	export HTTPS_PROXY=http://$PROXY_USER:$PROXY_PASS@proxy-url:8080
	export no_proxy="localhost,127.0.0.1,localaddress,.localdomain,127.*,192.168.*,172.*,10.*"
	export NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain,127.*,192.168.*,172.*,10.*"
	export PIP_INDEX_URL=https://$PROXY_USER:$PROXY_PASS@repository.com
	export npm_config_proxy=$http_proxy
	export npm_config_https_proxy=$https_proxy
}


# On a headless server
export EDITOR='vim'
export GIT_EDITOR=$EDITOR
export GIT_OPEN_URL=echo
```

The `.extra` dotfile enables to override default variables and is not tracked.


## Git

The variable `$GIT_EDITOR` define the editor used by git.

Requirements for `git tools`:
- `bcomp` should be defined for Linux or macOS (ex: `ln -s /usr/bin/bcompare $APPS/bin/bcomp`)
- `$WINMERGE_BIN` should be defined in `.extra` dotfile (`C:\Program Files (x86)\WinMerge\WinMergeU.exe`)

The variable `$GIT_OPEN_URL` define the way to open the URL git:
- `open` on Linux
- `start` on Windows
- `echo` on a headless server (Override the variable in the `.extra` dotfile)
