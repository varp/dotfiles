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


FORCE_INSTALL?=false

.PHONY: help bin-folder \
$(SRC_DOTFILES) dotfiles-dotfiles \
$(SRC_VSCODE_SETTINGS) dotfiles-vscode \
dev-node dev-go dev-php \
editor-micro editor-micro-plugins editor-neovim \
tool-brew tool-powerline-go tool-bat tool-zoxide tool-fzf tool-ripgrep \
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

#: Install Neovim (see: https://github.com/neovim/neovim) #editors
editor-neovim: tool-brew
	@if [[ "$(FORCE_INSTALL)" != "false" ]] || ! command -v nvim >/dev/null; then \
		if [[ "$$(uname -s)" == "Darwin" ]]; then \
			brew install neovim; \
		else \
			curl -L https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb -o /tmp/nvim-linux64.deb && \
			apt install -y /tmp/nvim-linux64.deb && apt install -fy; \
		fi \
	else \
		echo -e "$(@):\n $$(nvim --version)"; \
	fi

#: Install micro (see: https://micro-editor.github.io/) #editors
editor-micro: tool-brew
	@if ! command -v micro >/dev/null; then \
		if [ "$$(uname -s)" == "Darwin" ]; then \
			brew install micro; \
		else \
			cd $(DST_BIN_DIR) && curl https://getmic.ro | bash; \
		fi \
	else \
		echo -e "$(@):\n $$(micro --version)"; \
	fi

#: Install micro plugins: joinLines, detectident, quoter #editors
editor-micro-plugins: editor-micro
	@if command -v micro >/dev/null; then \
		for plugin in "joinLines" "detectindent" "quoter"; do \
			micro -plugin install $$plugin; \
		done \
	else \
		echo -e "$(@):\n micro editor is not installed"; \
	fi

#: Install Homebrew (see: https://brew.sh) #tools
tool-brew:
	@if [[ "$$(uname -s)" == "Darwin" ]]; then \
		if [[ "$(FORCE_INSTALL)" != "false" ]] || ! brew --version >/dev/null; then \
			/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		fi \
	fi

#: Install powerline-go (see: https://github.com/justjanne/powerline-go) #tools
tool-powerline-go: dev-go bin-folder
	@platAsset="powerline-go-$$(go env GOOS)-$$(go env GOARCH)"; \
	url="https://github.com/justjanne/powerline-go/releases/latest/download/$$platAsset"; \
	curl -L $$url -o $(DST_BIN_DIR)/powerline-go; \
	chmod a+x $(DST_BIN_DIR)/powerline-go


#: Install oh-my-posh (see: https://ohmyposh.dev/) #tools
tool-oh-my-posh: bin-folder
	curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/bin

#: Install bat (see: https://github.com/sharkdp/bat) #tools
tool-bat: tool-brew
	@if  [[ "$(FORCE_INSTALL)" != "false" ]] || ! command -v bat >/dev/null; then \
		if [ "$$(uname -s)" == "Darwin" ]; then \
			brew install bat; \
		else \
			sudo apt install -y bat; \
		fi \
	else \
		echo -e "$(@):\n $$(bat --version)"; \
	fi	

#: Install zoxide (see: https://github.com/ajeetdsouza/zoxide) #tools
tool-zoxide: tool-brew
	@if  [[ "$(FORCE_INSTALL)" != "false" ]] || ! command -v zoxide >/dev/null; then \
		if [ "$$(uname -s)" == "Darwin" ]; then \
			brew install zoxide; \
		else \
			sudo apt install -y zoxide; \
		fi \
	else \
		echo -e "$(@):\n $$(zoxide --version)"; \
	fi	


#: Install fzf (see: https://github.com/junegunn/fzf) #tools
tool-fzf: tool-brew
	@if  [[ "$(FORCE_INSTALL)" != "false" ]] || ! command -v fzf >/dev/null; then \
		if [ "$$(uname -s)" == "Darwin" ]; then \
			brew install fzf; \
		else \
			sudo apt install -y fzf; \
		fi \
	else \
		echo -e "$(@):\n $$(fzf --version)"; \
	fi	

#: Install ripgrep (see: https://github.com/BurntSushi/ripgrep) #tools
tool-ripgrep: tool-brew
	@if  [[ "$(FORCE_INSTALL)" != "false" ]] || ! command -v ripgrep >/dev/null; then \
		if [ "$$(uname -s)" == "Darwin" ]; then \
			brew install ripgrep; \
		else \
			sudo apt install -y ripgrep; \
		fi \
	else \
		echo -e "$(@):\n $$(rg --version)"; \
	fi	


#: Install NodeJs (see: https://nodejs.org) #dev
dev-node: tool-brew
	@if [[ "$(FORCE_INSTALL)" != "false" ]] || ! command -v node >/dev/null; then \
		if [ "$$(uname -s)" == "Darwin" ]; then \
			brew install node; \
		else \
			curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -; \
			sudo apt install -y nodejs; \
		fi \
	else \
		echo -e "$(@):\n $$(node --version)"; \
	fi	

#: Install nvm (NodeJs version manager)
dev-node-nvm:
	@if [[ "$(FORCE_INSTALL)" != "false" ]] || ! command -v nvm >/dev/null; then \
		PROFILE=/dev/null bash -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash"; \
	else \
		echo -e "$(@):\n $$(nvm --version)"; \
	fi	

#: Install Go (see: https://go.dev) #dev
dev-go: tool-brew
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
dev-php: tool-brew
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
@base-tools: tool-powerline-go tool-oh-my-posh tool-bat tool-zoxide tool-fzf tool-ripgrep

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
editors: editor-micro editor-micro-plugins

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
