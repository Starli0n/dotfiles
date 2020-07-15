OS_TYPE = $(shell uname)

export SRC_DIR ?= $(shell dirname $(shell dirname $(shell dirname $(CURDIR))))
LF=$(shell $'\n')

SHELL = bash
.ONESHELL:

.PHONY: env
env:
	@echo OS_TYPE=$(OS_TYPE)
	echo HOME=$(HOME)
	echo CURDIR=$(CURDIR)
	echo SRC_DIR=$(SRC_DIR)
	echo "python => $(shell which python)"
	echo "python3 => $(shell which python3)"

.PHONY: all
all: backup dotfiles extra applications system

.PHONY: ubuntu
ubuntu: backup apt-get dotfiles-zsh dotfiles-others extra applications system

.PHONY: apt-get
apt-get:
	sudo apt-get update -y
	sudo apt-get install -y curl git zsh \
		wmctrl xbindkeys xvkbd # Key bindings and shortcuts

.PHONY: backup
backup: # Testing: rm -f $HOME/.*.default
	@for file in .bashrc .profile .zshrc; do
		if [[ ! -f "$(HOME)/$$file.default" ]]; then
			cp "$(HOME)/$$file" "$(HOME)/$$file.default"
			echo "$(HOME)/$$file.default"
		fi
	done

.PHONY: dotfiles
dotfiles: dotfiles-bash dotfiles-zsh dotfiles-zsh-sesu dotfiles-others

.PHONY: dotfiles-bash
dotfiles-bash:
	@make DOTFILE=.bash_profile -s symlink
	make DOTFILE=.bashrc -s symlink
	make DOTFILE=.profile -s symlink

.PHONY: dotfiles-zsh
dotfiles-zsh:
	@make DOTFILE=.zshrc -s symlink
	ln -sfn $(CURDIR)/starli0n.zsh-theme $(HOME)/.oh-my-zsh/themes/starli0n.zsh-theme
	echo $(HOME)/.oh-my-zsh/themes/starli0n.zsh-theme

.PHONY: dotfiles-zsh-sesu
dotfiles-zsh-sesu:
	@make DOTFILE=.shell_zsh_sesu.sh -s symlink
	@make DOTFILE=.shell_zsh.sh -s symlink

.PHONY: dotfiles-others
dotfiles-others:
	@touch ".extra"
	make DOTFILE=.extra -s symlink
	make DOTFILE=.dockerfunc -s symlink
	make DOTFILE=.gitconfig -s symlink
	make DOTFILE=.gitools.sh -s symlink
	make DOTFILE=.npmrc -s symlink
	make DOTFILE=.starrc -s symlink
	make DOTFILE=.vimrc -s symlink
	make DOTFILE=.xbindkeysrc -s symlink
	mkdir -p "$(SRC_DIR)/github.com"
	envsubst < "$(CURDIR)/.gitconfig.id" > "$(HOME)/.gitconfig.id"
	echo "$(HOME)/.gitconfig.id"
	cp "$(CURDIR)/.gitconfig.inc" "$(SRC_DIR)/github.com/.gitconfig.inc"
	echo "$(SRC_DIR)/github.com/.gitconfig.inc"

.PHONY: symlink
symlink:
	ln -sfn "$(CURDIR)/$(DOTFILE)" "$(HOME)/$(DOTFILE)"
	echo "$(HOME)/$(DOTFILE)"

.PHONY: extra
extra:
	@export PY3='$(shell which python3 > /dev/null 2>&1 || echo "# ")'
	export WORK=$(CURDIR)
	envsubst < .extra.tpl >> .extra
	echo .extra

.PHONY: headless
headless:
	cat <<- EOF >> .extra
		$(LF)
		# On a headless server
		export EDITOR='vim'
		export GIT_EDITOR=$$EDITOR
		export GIT_NO_GUI=--git-no-gui # Used in ~/gitools.sh for difftool
		export GIT_OPEN_URL=echo
	EOF

.PHONY: applications
applications: # APPS is same as in .starrc
	# Add color to git config
	APPS_BIN="$(HOME)/.local/bin"
	mkdir -p $$APPS_BIN
	cp -R $(CURDIR)/apps/colorcfg $$APPS_BIN/colorcfg
	cd $$APPS_BIN/colorcfg && python3 -m compileall -b . || python -m compileall .

.PHONY: system
system: # System specific
	if [[ "$(OS_TYPE)" == "Linux" ]]; then
		git config --global --unset core.autocrlf
	elif [[ "$(OS_TYPE)" == "Darwin" ]]; then
		git config --global --unset core.autocrlf
		git config --global core.pager cat
	else
		git config --global --unset core.pager
		git config --global core.askpass git-gui--askpass
		git config --global core.autocrlf input
	fi

.PHONY: win
win: extra win-export system

.PHONY: win-export
win-export:
	touch "$(HOME)/.extra"
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".gitconfig"); do
		f=$$(basename $$file)
		cp "$$file" "$(HOME)/$$f"
	done
	cp "$(CURDIR)/.gitconfig" "$(HOME)/.gitconfig"

.PHONY: win-import
win-import:
	touch "$(HOME)/.extra"
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".gitconfig"); do
		f=$$(basename $$file)
		cp "$(HOME)/$$f" "$$file"
	done
	cp "$(HOME)/.gitconfig" "$(CURDIR)/.gitconfig"
