# Dotfiles ![](https://github.com/varp/dotfiles/workflows/test/badge.svg)

Collections of dotfiles and several Makefile targets to install tools and etc.

## Installation

1. Just use git to clone the repository to your system: `git clone https://github.com/varp/dotfiles.git && cd dotfiles`. 
2. Run `make dotfiles`

## Targets
To see list of available targets with descriptions run `make`. Targets are organized into groups - third column on the output below.
```
dotfiles-dotfiles      Install dotfiles                                                                    dotfiles
dotfiles-vscode        Install VS Code settings                                                            dotfiles
editor-vim-vundle      Install VimVundle package mamanger (see: https://github.com/VundleVim/Vundle.vim)   editors
editor-micro           Install micro (see: https://micro-editor.github.io/)                                editors
tool-powerline-go      Install powerline-go (see: https://github.com/justjanne/powerline-go)               tools
tool-brew              Install Homebrew (see: https://brew.sh)                                             tools
dev-node               Install NodeJs (see: https://nodejs.org)                                            dev
dev-go                 Install Go (see: https://go.dev)                                                    dev
dev-php                Install PHP (see: https://php.net)                                                  dev
dotfiles               Installs dotfiles, micro, VimVundle. On MacOS: VS Code settigns, Homebrew           group
editors                Installs micro and VimVundle
tools                  Installs powerline-go. On MacOS: Homebrew                                           group
devs                   Installs PHP, Go, NodeJS                                                            group
all                    Installs all groups                                                                 group
clean-dotfiles         Uninstalls dotfiles
clean-vscode-settings  Uninstalls VS Code settings
clean                  Uninstalls dotfiles and VS Code settings
```

# Links
- [A lot of tweaks for MacOS GUI and many more!](https://github.com/mathiasbynens/dotfiles/blob/master/.macos)