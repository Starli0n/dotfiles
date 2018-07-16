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
