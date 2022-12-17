SHELL=/bin/bash

LOCAL_BIN_DIR?=/usr/local/bin

DST_BASE_DIR?=$(HOME)

DST_BIN_DIR?=$(DST_BASE_DIR)/bin

SRC_DOTFILES_DIR=dotfiles
SRC_DOTFILES=$(shell cd ./$(SRC_DOTFILES_DIR) && find . -type f -and -not -name '\.*')
DST_DOTFILES_DIR?=$(DST_BASE_DIR)

SRC_VSCODE_SETTINGS_DIR=vscode
SRC_VSCODE_SETTINGS=$(shell cd ./$(SRC_VSCODE_SETTINGS_DIR) && find . -type f -and -not -name '\.*')
DEST_VSCODE_SETTINGS_DIR?="$(DST_BASE_DIR)/Library/Application Support/Code/User"

VIM_VUNDLE_DIR=$(DST_DOTFILES_DIR)/.vim/bundle
VIM_VUNDLE_REPO=https://github.com/VundleVim/Vundle.vim.git

.PHONY: help bin-folder \
$(SRC_DOTFILES) dotfiles-dotfiles \
$(SRC_VSCODE_SETTINGS) dotfiles-vscode \
dev-node dev-go dev-php \
editor-vim-vundle editor-micro \
tool-brew tool-powerline-go tool-bat \
@base @base-tools @dotfiles-group @tools-group \
dotfiles tools editors devs \
all \
clean-dotfiles-dotfiles clean-dotfiles-vscode \
clen

.DEFAULT_GOAL: help
help:
	@grep -B1 -E "^[a-zA-Z0-9_-]+\:([^\=]|$$)" Makefile \
     | grep -v -- -- \
     | sed 'N;s/\n/###/' \
     | sed -n 's/^#: \(.*\)###\(.*\):.*/\2###\1/p' \
     | column -t  -s '###'

bin-folder:
	-@[ ! -d $(DST_BIN_DIR) ] && mkdir -p $(DST_BIN_DIR)
	-@[ ! -d $(LOCAL_BIN_DIR) ] && mkdir -p $(LOCAL_BIN_DIR)

$(SRC_DOTFILES):
	-@mkdir -p $(dir $(addprefix $(DST_DOTFILES_DIR)/.,$@))	
	-@[ -f $(addprefix $(DST_DOTFILES_DIR)/.,$@) ] && unlink $(addprefix $(DST_DOTFILES_DIR)/.,$@)

#: Install dotfiles #dotfiles
dotfiles-dotfiles: $(SRC_DOTFILES)
	@for dotfile in $?; do \
		src=$(addprefix $(realpath $(SRC_DOTFILES_DIR))/, $$dotfile); \
		dst=$(addprefix $(DST_DOTFILES_DIR)/.,$$dotfile); \
		ln -vsf "$$src" "$$dst"; \
	done

$(SRC_VSCODE_SETTINGS):
	-@[ -f $(addprefix $(DEST_VSCODE_SETTINGS_DIR)/,$@) ] && unlink $(addprefix $(DEST_VSCODE_SETTINGS_DIR)/,$@)
	
#: Install VS Code settings #dotfiles
dotfiles-vscode: $(SRC_VSCODE_SETTINGS)
	@mkdir -p $(DEST_VSCODE_SETTINGS_DIR) || ls -la  $(DEST_VSCODE_SETTINGS_DIR)
	@for vscodeDotFile in $?; do \
		src=$(addprefix $(realpath $(SRC_VSCODE_SETTINGS_DIR))/, $$vscodeDotFile); \
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
			cd $(DST_BIN_DIR) && curl https://getmic.ro | bash; \
		fi \
	else \
		echo -e "$(@):\n $$(micro --version)"; \
	fi

#: Install powerline-go (see: https://github.com/justjanne/powerline-go) #tools
tool-powerline-go: dev-go bin-folder
	@platAsset="powerline-go-$$(go env GOOS)-$$(go env GOARCH)"; \
	url="https://github.com/justjanne/powerline-go/releases/latest/download/$$platAsset"; \
	curl -L $$url -o $(DST_BIN_DIR)/powerline-go; \
	chmod a+x $(DST_BIN_DIR)/powerline-go

#: Install Homebrew (see: https://brew.sh) #tools
tool-brew:
	@if [ "$$(uname -s)" == "Darwin" ]; then \
		if ! brew --version >/dev/null; then \
			/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		fi \
	fi

#: Install bat (see: https://github.com/sharkdp/bat) #tools
tool-bat: brew
	@if ! command -v bat >/dev/null; then \
		if [ "$$(uname -s)" == "Darwin" ]; then \
			brew install bat; \
		else \
			sudo apt install -y bat; \
		fi \
	else \
		echo -e "$(@):\n $$(bat --version)"; \
	fi	

#: Install NodeJs (see: https://nodejs.org) #dev
dev-node: brew
	@if ! command -v node >/dev/null; then \
		if [ "$$(uname -s)" == "Darwin" ]; then \
			brew install node; \
		else \
			curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -; \
			sudo apt install -y nodejs; \
		fi \
	else \
		echo -e "$(@):\n $$(node --version)"; \
	fi	

#: Install Go (see: https://go.dev) #dev
dev-go: brew
	@if ! command -v go >/dev/null; then \
		if [ "$$(uname -s)" = "Darwin" ]; then \
			brew install go; \
		else \
			sudo apt install -y golang; \
		fi \
	else \
		echo -e "$(@):\n $$(go version)"; \
	fi

#: Install PHP (see: https://php.net) #dev
dev-php: brew
	@if ! command -v php >/dev/null; then \
		if [ "$$(uname -s)" == "Darwin" ]; then \
			brew install php; \
		else \
			sudo apt install -y php; \
		fi \
	else \
		echo -e "$(@):\n $$(php --version)"; \
	fi


release-tag:
	git tag -f v$$(date +%Y%m%d); git push -u origin HEAD; git push --tags --force origin HEAD


@base: dotfiles-dotfiles bin-folder 
@base-tools: tool-powerline-go tool-bat

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
clean-dotfiles-dotfiles: $(SRC_DOTFILES)
#: Uninstalls VS Code settings
clean-dotfiles-vscode: $(SRC_VSCODE_SETTINGS)	
#: Uninstalls dotfiles and VS Code settings
clean: clean-dotfiles-dotfiles clean-dotfiles-vscode
