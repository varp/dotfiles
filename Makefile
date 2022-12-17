SHELL=/bin/bash

SOURCE_BINFILES=bin/*

SOURCE_DOTFILES_DIR=dotfiles
SOURCE_DOTFILES=$(shell cd ./$(SOURCE_DOTFILES_DIR) && find . -type f -and -not -name '\.*')

DEST_DOTFILES_DIR=$(HOME)

SOURCE_VSCODE_SETTINGS_DIR=vscode
SOURCE_VSCODE_SETTINGS=$(shell cd ./$(SOURCE_VSCODE_SETTINGS_DIR) && find . -type f -and -not -name '\.*')
DEST_VSCODE_SETTINGS_DIR?="$(HOME)/Library/Application Support/Code/User"

VIM_VUNDLE_DIR=$(DEST_DOTFILES_DIR)/.vim/bundle
VIM_VUNDLE_REPO=https://github.com/VundleVim/Vundle.vim.git

.SILENT:

.PHONY: help bin-folder \
$(SOURCE_DOTFILES) dotfiles \
dev-node dev-go dev-php \
$(SOURCE_VSCODE_SETTINGS) dotfiles-vscode \
editor-vim-vundle editor-micro \
tool-brew tool-powerline-go  \
@base @base-tools @core @tools \
core tools devs all

.DEFAULT_GOAL: help
help:
	@grep -B1 -E "^[a-zA-Z0-9_-]+\:([^\=]|$$)" Makefile \
     | grep -v -- -- \
     | sed 'N;s/\n/###/' \
     | sed -n 's/^#: \(.*\)###\(.*\):.*/\2###\1/p' \
     | column -t  -s '###'

bin-folder:
	-@[ ! -d $(HOME)/bin ] && mkdir -p $(HOME)/bin

$(SOURCE_DOTFILES):
	-@mkdir -p $(dir $(addprefix $(DEST_DOTFILES_DIR)/.,$@))	
	-@[ -f $(addprefix $(DEST_DOTFILES_DIR)/.,$@) ] && unlink $(addprefix $(DEST_DOTFILES_DIR)/.,$@)

#: Install dotfiles #dotfiles
dotfiles-dotfiles: $(SOURCE_DOTFILES)
	@for dotfile in $?; do \
		src=$(addprefix $(realpath $(SOURCE_DOTFILES_DIR))/, $$dotfile); \
		dst=$(addprefix $(DEST_DOTFILES_DIR)/.,$$dotfile); \
		ln -vsf "$$src" "$$dst"; \
	done

$(SOURCE_VSCODE_SETTINGS):
	-@[ -f $(addprefix $(DEST_VSCODE_SETTINGS_DIR)/,$@) ] && unlink $(addprefix $(DEST_VSCODE_SETTINGS_DIR)/,$@)
	
#: Install VS Code settings #dotfiles
dotfiles-vscode: $(SOURCE_VSCODE_SETTINGS)
	@mkdir -p $(DEST_VSCODE_SETTINGS_DIR) || ls -la  $(DEST_VSCODE_SETTINGS_DIR)
	@for vscodeDotFile in $?; do \
		src=$(addprefix $(realpath $(SOURCE_VSCODE_SETTINGS_DIR))/, $$vscodeDotFile); \
		dst=$(addprefix $(DEST_VSCODE_SETTINGS_DIR)/,$$vscodeDotFile); \
		ln -vsf "$$src" "$$dst"; \
	done
	
#: Install VimVundle package mamanger (see: https://github.com/VundleVim/Vundle.vim) #editors
editor-vim-vundle: 
	-@[ -L $(VIM_VUNDLE_DIR) ] && unlink $(VIM_VUNDLE_DIR)
	-@[ -d $(VIM_VUNDLE_DIR) ] && rm -rf $(VIM_VUNDLE_DIR)
	-@mkdir -p $(VIM_VUNDLE_DIR)
	git clone $(VIM_VUNDLE_REPO) $(VIM_VUNDLE_DIR)/Vundle.vim

#: Install micro (see: https://micro-editor.github.io/) #editors
editor-micro:
	@if ! command -v micro >/dev/null; then \
		if [ "$$(uname -s)" == "Darwin" ]; then \
			brew install micro; \
		else \
			curl https://getmic.ro | bash; \
		fi \
	else \
		micro --version; \
	fi

#: Install powerline-go (see: https://github.com/justjanne/powerline-go) #tools
tool-powerline-go: dev-go make-bin-folder
	@platAsset="powerline-go-$$(go env GOOS)-$$(go env GOARCH)"; \
	url="https://github.com/justjanne/powerline-go/releases/latest/download/$$platAsset"; \
	curl -L $$url -o $(HOME)/bin/powerline-go; \
	chmod a+x $(HOME)/bin/powerline-go

#: Install Homebrew (see: https://brew.sh) #tools
tool-brew:
	@if [ "$$(uname -s)" == "Darwin" ]; then \
		if ! brew --version >/dev/null; then \
			/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		fi \
	fi

#: Install NodeJs (see: https://nodejs.org) #dev
dev-node: brew
	@if ! command -v node >/dev/null; then \
		if [ "$$(uname -s)" == "Darwin" ]; then \
			brew install node; \
		else \
			curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -; \
			sudo apt-get install -y nodejs; \
		fi \
	else \
		node version; \
	fi	

#: Install Go (see: https://go.dev) #dev
dev-go: brew
	@if ! command -v go >/dev/null; then \
		if [ "$$(uname -s)" = "Darwin" ]; then \
			brew install go; \
		else \
			sudo apt install golang; \
		fi \
	else \
		go version; \
	fi

#: Install PHP (see: https://php.net) #dev
dev-php: brew
	@if ! command -v php >/dev/null; then \
		if [ "$$(uname -s)" == "Darwin" ]; then \
			brew install php; \
		else \
			sudo apt install php; \
		fi \
	else \
		php --version; \
	fi


release-tag:
	git tag -f v$$(date +%Y%m%d); git push -u origin HEAD; git push --tags --force origin HEAD


@base: dotfiles-dotifles bin-folder 
@base-tools: tool-powerline-go

ifeq ($(shell uname -s), Darwin)
@dotfiles-group: @base dotfiles-vscode
@tools-group: @base-tools tool-brew
else
@dotfiles-group: @base
@tools-group: @base-tools
endif

#: Installs dotfiles, micro, VimVundle. On MacOS: VS Code settigns, Homebrew #group
dotfiles: @dotfiles-group

#: Installs micro and VimVundle
editors: editor-micro editor-vim-vundle

#: Installs powerline-go. On MacOS: Homebrew #group
tools: @tools-group

#: Installs PHP, Go, NodeJS #group
devs: dev-php dev-go dev-node

#: Installs all groups #group
all: dotfiles editors tools devs


#: Uninstalls dotfiles
clean-dotfiles: $(SOURCE_DOTFILES)
#: Uninstalls VS Code settings
clean-vscode-settings: $(SOURCE_VSCODE_SETTINGS)	
#: Uninstalls dotfiles and VS Code settings
clean: clean-dotfiles clean-vscode-settings
