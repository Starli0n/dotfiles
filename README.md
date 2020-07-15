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


## Prerequisite

- [Installing ZSH](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
- [Install oh-my-zsh now](https://ohmyz.sh/#install)


## Before Installation

```sh
$ cd
$ mkdir -p $HOME/src/github.com/Starli0n
$ cd $HOME/src/github.com/Starli0n
$ git clone https://github.com/Starli0n/dotfiles.git
$ cd dotfiles
```

Assuming the command above was followed, the [default source directory](https://github.com/Starli0n/dotfiles/blob/master/Makefile#L3) is set to
  - `$SRC_DIR = $HOME\src` _(parent of parent of parent of this repository)_

The folder `src` can be changed to something like `Develop/Sources` therefore the variable `$SRC_DIR` will be computed as a consequence.

Alternatively, the variable `$SRC_DIR` could be set manually with `export SRC_DIR=path-to-source` before installation if the architecture `$SRC_DIR/organization/user` is not respected.


## Installation

* Linux or macOS
	* `make all`
* Ubuntu
	* `make ubuntu`
* Windows _(Check `$HOME` before)_
	* `make win`

Add some specific into the `.extra` dotfile like proxy etc...
```sh
# Add here extra paths
export PATH:$PATH:$EXTRA_PATH

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

# On a headless server => make headless
export EDITOR='vim'
export GIT_EDITOR=$EDITOR
export GIT_NO_GUI=--git-no-gui # Used in ~/gitools.sh for difftool
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

## Ubuntu

### Keyboard Shortcuts

`Custom Shortcuts`

```
Activate Firefox
wmctrl -x -a Navigator.Firefox
Super + F

Activate Gedit
wmctrl -x -a org.gnome.gedit.Org.gnome.gedit
Ctrl + <

Activate Nautilus
wmctrl -x -a org.gnome.Nautilus.Org.gnome.Nautilus
Super + E

Activate Terminal
wmctrl -x -a gnome-terminal-server.Gnome-terminal
Ctrl + ²
```

List apps: `wmctrl -lx`

### Install Docker (TODO)

- https://docs.docker.com/install/linux/docker-ce/ubuntu

- https://medium.com/@Grigorkh/how-to-install-docker-on-ubuntu-19-10-60feae8fd382
