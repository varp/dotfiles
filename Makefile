SOURCE_BINFILES=bin/*

SOURCE_DOTFILES_DIR=dotfiles
SOURCE_DOTFILES=$(shell cd ./$(SOURCE_DOTFILES_DIR) && find . -type f)
DEST_DOTFILES_DIR=$(HOME)

SOURCE_VSCODE_SETTINGS_DIR=vscode
SOURCE_VSCODE_SETTINGS=$(shell cd ./$(SOURCE_VSCODE_SETTINGS_DIR) && find . -type f)
DEST_VSCODE_SETTINGS_DIR?="$(HOME)/Library/Application Support/Code/User"

VIM_VUNDLE_DIR=$(DEST_DOTFILES_DIR)/.vim/bundle
VIM_VUNDLE_REPO=https://github.com/VundleVim/Vundle.vim.git

.SILENT:

.PHONY: $(SOURCE_DOTFILES) dotfiles \
brew dev-go dev-php \
$(SOURCE_VSCODE_SETTINGS) editor-vscode-settings editor-vim-vundle micro \
tools-shell-powerline-go 
	
ifeq ($(shell uname -s), Darwin)
all: base editor-vscode-settings
else
all: base
endif

base: dotfiles tools-shell-powerline-go micro editor-vim-vundle


$(SOURCE_DOTFILES):
	-@mkdir -p $(dir $(addprefix $(DEST_DOTFILES_DIR)/.,$@))	
	-@[ -f $(addprefix $(DEST_DOTFILES_DIR)/.,$@) ] && unlink $(addprefix $(DEST_DOTFILES_DIR)/.,$@)

dotfiles: $(SOURCE_DOTFILES)
	@for dotfile in $?; do \
		src=$(addprefix $(realpath $(SOURCE_DOTFILES_DIR))/, $$dotfile); \
		dst=$(addprefix $(DEST_DOTFILES_DIR)/.,$$dotfile); \
		ln -vsf "$$src" "$$dst"; \
	done

$(SOURCE_VSCODE_SETTINGS):
	-@[ -f $(addprefix $(DEST_VSCODE_SETTINGS_DIR)/,$@) ] && unlink $(addprefix $(DEST_VSCODE_SETTINGS_DIR)/,$@)
	@ln -vsf "$(realpath $(SOURCE_VSCODE_SETTINGS_DIR)/$@)" $(addprefix $(DEST_VSCODE_SETTINGS_DIR)/,$@)

editor-vscode-settings: $(SOURCE_VSCODE_SETTINGS)

editor-vim-vundle: 
	-@[ -L $(VIM_VUNDLE_DIR) ] && unlink $(VIM_VUNDLE_DIR)
	-@[ -d $(VIM_VUNDLE_DIR) ] && rm -rf $(VIM_VUNDLE_DIR)
	-@mkdir -p $(VIM_VUNDLE_DIR)
	-git clone $(VIM_VUNDLE_REPO) $(VIM_VUNDLE_DIR)/Vundle.vim

micro:
	@if ! command -v micro >/dev/null; then \
		if [ "$$(uname -s)" == "Darwin" ]; then \
			brew install micro; \
		else \
			curl https://getmic.ro | bash; \
		fi \
	else \
		micro --version; \
	fi

brew:
	@if [ "$$(uname -s)" == "Darwin" ]; then \
		if ! brew --version >/dev/null; then \
			/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		fi \
	fi

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

dev-go: brew
	@if ! command -v go >/dev/null; then \
		if [ "$$(uname -s)" == "Darwin" ]; then \
			brew install go; \
		else \
			sudo apt install golang; \
		fi \
	else \
		go version; \
	fi

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

tools-shell-powerline-go: dev-go
	@platAsset="powerline-go-$$(go env GOOS)-$$(go env GOARCH)"; \
	url="https://github.com/justjanne/powerline-go/releases/latest/download/$$platAsset"; \
	curl -L $$url -o $(HOME)/bin/powerline-go; \
	chmod a+x $(HOME)/bin/powerline-go
