SHELL=/bin/bash

SOURCE_BINFILES=bin/*

SOURCE_DOTFILES_DIR=dotfiles
SOURCE_DOTFILES=$(shell cd ./$(SOURCE_DOTFILES_DIR) && find -E . -type f -and -not -name '\.*')

DEST_DOTFILES_DIR=$(HOME)

SOURCE_VSCODE_SETTINGS_DIR=vscode
SOURCE_VSCODE_SETTINGS=$(shell cd ./$(SOURCE_VSCODE_SETTINGS_DIR) && find -E . -type f -and -not -name '\.*')
DEST_VSCODE_SETTINGS_DIR?="$(HOME)/Library/Application Support/Code/User"

VIM_VUNDLE_DIR=$(DEST_DOTFILES_DIR)/.vim/bundle
VIM_VUNDLE_REPO=https://github.com/VundleVim/Vundle.vim.git

.SILENT:

.PHONY: make-bin-folder \
$(SOURCE_DOTFILES) dotfiles \
brew dev-go dev-php \
$(SOURCE_VSCODE_SETTINGS) editor-vscode-settings editor-vim-vundle micro \
tools-shell-powerline-go 

make-bin-folder:
	-@[ ! -d $(HOME)/bin ] && mkdir -p $(HOME)/bin

## SETUP DOTFILES
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
	

editor-vscode-settings: $(SOURCE_VSCODE_SETTINGS)
	@for vscodeDotFile in $?; do \
		src=$(addprefix $(realpath $(SOURCE_VSCODE_SETTINGS_DIR))/, $$vscodeDotFile); \
		dst=$(addprefix $(DEST_VSCODE_SETTINGS_DIR)/,$$vscodeDotFile); \
		ln -vsf "$$src" "$$dst"; \
	done
	

editor-vim-vundle: 
	-@[ -L $(VIM_VUNDLE_DIR) ] && unlink $(VIM_VUNDLE_DIR)
	-@[ -d $(VIM_VUNDLE_DIR) ] && rm -rf $(VIM_VUNDLE_DIR)
	-@mkdir -p $(VIM_VUNDLE_DIR)
	-git clone $(VIM_VUNDLE_REPO) $(VIM_VUNDLE_DIR)/Vundle.vim

## SETUP TOOLS

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
		if [ "$$(uname -s)" = "Darwin" ]; then \
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

tools-shell-powerline-go: dev-go make-bin-folder
	@platAsset="powerline-go-$$(go env GOOS)-$$(go env GOARCH)"; \
	url="https://github.com/justjanne/powerline-go/releases/latest/download/$$platAsset"; \
	curl -L $$url -o $(HOME)/bin/powerline-go; \
	chmod a+x $(HOME)/bin/powerline-go

### CI/CD
release-tag:
	git tag -f v$$(date +%Y%m%d); git push -u origin HEAD; git push --tags --force origin HEAD


### MAIN TARGETS

## SETUP
base: dotfiles tools-shell-powerline-go micro editor-vim-vundle

ifeq ($(shell uname -s), Darwin)
all: base editor-vscode-settings
else
all: base
endif

## CLEAN
clean-dotfiles: $(SOURCE_DOTFILES)

clean-vscode-settings: $(SOURCE_VSCODE_SETTINGS)	

clean: clean-dotfiles clean-vscode-settings
