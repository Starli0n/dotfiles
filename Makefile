OS_TYPE=$(shell uname)

.PHONY: env
env:
	@echo HOME=$(HOME)
	@echo CURDIR=$(CURDIR)
	@echo OS_TYPE=$(OS_TYPE)

.PHONY: all
all: dotfiles extra applications system

.PHONY: dotfiles
dotfiles: ## Installs the dotfiles.
	touch ".extra"
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".gitconfig"); do \
		f=$$(basename $$file); \
		ln -sfn "$$file" "$(HOME)/$$f"; \
	done; \
	ln -sfn "$(CURDIR)/.gitconfig" "$(HOME)/.gitconfig"
	ln -sfn "$(CURDIR)/starli0n.zsh-theme" "$(HOME)/.oh-my-zsh/themes/starli0n.zsh-theme"

.PHONY: extra
extra: ## Create .extra dotfile
	echo "alias gguser='git config --global user.name Starli0n; git config --global user.email Starli0n@users.noreply.github.com'">>"$(HOME)/.extra"
	echo "alias guser='git config user.name Starli0n; git config user.email Starli0n@users.noreply.github.com'">>"$(HOME)/.extra"

.PHONY: applications
applications:
	mkdir -p $(HOME)/.ssh
	mkdir -p $(HOME)/apps/bin

	# Add color to git config
	cp -R $(CURDIR)/apps/colorcfg $(HOME)/apps/colorcfg
	cd $(HOME)/apps/colorcfg && python -m compileall .

	# Remote Sublime Text
	curl -Lo $(HOME)/apps/bin/rsub https://raw.githubusercontent.com/aurora/rmate/master/rmate --insecure
	chmod a+x $(HOME)/apps/bin/rsub
	ln -sfn $(CURDIR)/.ssh/config $(HOME)/.ssh/config

.PHONY: system
system: ## System specific
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
