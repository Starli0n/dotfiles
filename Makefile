OS_TYPE=$(shell uname)

SHELL = bash
.ONESHELL:

.PHONY: env
env:
	@echo HOME=$(HOME)
	@echo CURDIR=$(CURDIR)
	@echo OS_TYPE=$(OS_TYPE)

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
backup:
	@for file in .bashrc .profile .zshrc; do \
		cp "$(HOME)/$$file" "$(HOME)/$$file.default"; \
	done; \

.PHONY: dotfiles
dotfiles: dotfiles-bash dotfiles-zsh dotfiles-zsh-sesu dotfiles-others

.PHONY: dotfiles-bash
dotfiles-bash:
	@make DOTFILE=.bash_profile -s symlink
	@make DOTFILE=.bashrc -s symlink
	@make DOTFILE=.profile -s symlink

.PHONY: dotfiles-zsh
dotfiles-zsh:
	@make DOTFILE=.zshrc -s symlink
	@make DOTFILE=.starli0n.zsh-theme -s symlink

.PHONY: dotfiles-zsh-sesu
dotfiles-zsh-sesu:
	@make DOTFILE=.shell_zsh_sesu.sh -s symlink
	@make DOTFILE=.shell_zsh.sh -s symlink

.PHONY: dotfiles-others
dotfiles-others:
	touch ".extra"
	@make DOTFILE=.extra -s symlink
	@make DOTFILE=.dockerfunc -s symlink
	@make DOTFILE=.gitconfig -s symlink
	@make DOTFILE=.gitools.sh -s symlink
	@make DOTFILE=.npmrc -s symlink
	@make DOTFILE=.starrc -s symlink
	@make DOTFILE=.vimrc -s symlink
	@make DOTFILE=.xbindkeysrc -s symlink
	mkdir -p "$(HOME)/Sources/github.com"
	cp "$(CURDIR)/.gitconfig.id" "$(HOME)/.gitconfig.id"
	cp "$(CURDIR)/.gitconfig.inc" "$(HOME)/Sources/github.com/.gitconfig.inc"

.PHONY: symlink
symlink:
	ln -sfn "$(CURDIR)/$(DOTFILE)" "$(HOME)/$(DOTFILE)"

.PHONY: extra
extra: ## Create .extra dotfile
	echo "alias gguser='git config --global user.name Starli0n; git config --global user.email Starli0n@users.noreply.github.com'">>"$(HOME)/.extra"
	echo "alias guser='git config user.name Starli0n; git config user.email Starli0n@users.noreply.github.com'">>"$(HOME)/.extra"

.PHONY: headless
headless:
	cat <<- EOF >> .extra
		# On a headless server
		export EDITOR='vim'
		export GIT_EDITOR=$$EDITOR
		export GIT_NO_GUI=--git-no-gui # Used in ~/gitools.sh for difftool
		export GIT_OPEN_URL=echo
	EOF

.PHONY: applications
applications:
	mkdir -p $(HOME)/.ssh
	mkdir -p $(HOME)/apps/bin

	# Remote Sublime Text
	curl -Lo $(HOME)/apps/bin/rsub https://raw.githubusercontent.com/aurora/rmate/master/rmate --insecure
	chmod a+x $(HOME)/apps/bin/rsub
	ln -sfn $(CURDIR)/.ssh/config $(HOME)/.ssh/config

	# Add color to git config
	cp -R $(CURDIR)/apps/colorcfg $(HOME)/apps/colorcfg
	cd $(HOME)/apps/colorcfg && python -m compileall .
	mv $(HOME)/apps/colorcfg/__pycache__/colorcfg.cpython-37.pyc $(HOME)/apps/colorcfg/colorcfg.pyc

.PHONY: system
system: # System specific
	if [[ "$(OS_TYPE)" == "Linux" ]]; then \
		git config --global --unset core.autocrlf; \
		:; \
	elif [[ "$(OS_TYPE)" == "Darwin" ]]; then \
		git config --global --unset core.autocrlf; \
		git config --global core.pager cat; :; \
		:; \
	else \
		git config --global --unset core.pager; \
		git config --global core.askpass git-gui--askpass; \
		git config --global core.autocrlf input; \
		:; \
	fi

.PHONY: win
win: win-export extra system

.PHONY: win-export
win-export:
	touch "$(HOME)/.extra"
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".gitconfig"); do \
		f=$$(basename $$file); \
		cp "$$file" "$(HOME)/$$f"; \
	done; \
	cp "$(CURDIR)/.gitconfig" "$(HOME)/.gitconfig"

.PHONY: win-import
win-import:
	touch "$(HOME)/.extra"
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".gitconfig"); do \
		f=$$(basename $$file); \
		cp "$(HOME)/$$f" "$$file"; \
	done; \
	cp "$(HOME)/.gitconfig" "$(CURDIR)/.gitconfig"
