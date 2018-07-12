.PHONY: all
all: dotfiles extra

.PHONY: dotfiles
dotfiles: ## Installs the dotfiles.
	touch .extra
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git"); do \
		f=$$(basename $$file); \
		ln -fn $$file $(HOME)/$$f; \
	done; \
	ln -sfn $(CURDIR)/starli0n.zsh-theme $(HOME)/.oh-my-zsh/themes/starli0n.zsh-theme

.PHONY: extra
extra: ## Create .extra dotfile
	echo "alias gguser='git config --global user.name Starli0n; git config --global user.email Starli0n@users.noreply.github.com'">>$(HOME)/.extra
	echo "alias guser='git config user.name Starli0n; git config user.email Starli0n@users.noreply.github.com'">>$(HOME)/.extra
