# Dotfiles ![](https://github.com/varp/dotfiles/workflows/test/badge.svg)

Collections of dotfiles and several Makefile targets to install tools and etc.

## Installation

1. Just use git to clone the repository to your system: `git clone https://github.com/varp/dotfiles.git && cd dotfiles`. 
2. Run `make dotfiles`

## Targets
To see list of available targets with descriptions run `make`. Targets are organized into groups - third column on the output below.
```
dotfiles-dotfiles        Install dotfiles                                                                          dotfiles
dotfiles-vscode          Install VS Code settings                                                                  dotfiles
editor-neovim            Install Neovim (see: https://github.com/neovim/neovim)                                    editors
editor-micro             Install micro (see: https://micro-editor.github.io/)                                      editors
editor-micro-plugins     Install micro plugins: joinLines, detectident, quoter                                     editors
tool-brew                Install Homebrew (see: https://brew.sh)                                                   tools
tool-powerline-go        Install powerline-go (see: https://github.com/justjanne/powerline-go)                     tools
tool-oh-my-posh          Install oh-my-posh (see: https://ohmyposh.dev/)                                           tools
tool-bat                 Install bat (see: https://github.com/sharkdp/bat)                                         tools
tool-zoxide              Install zoxide (see: https://github.com/ajeetdsouza/zoxide)                               tools
tool-fzf                 Install fzf (see: https://github.com/junegunn/fzf)                                        tools
tool-ripgrep             Install ripgrep (see: https://github.com/BurntSushi/ripgrep)                              tools
tool-time_ms             Compile and install tools/time_ms utility                                                 tools
dev-node                 Install NodeJs (see: https://nodejs.org)                                                  dev
dev-node-nvm             Install nvm (NodeJs version manager)
dev-go                   Install Go (see: https://go.dev)                                                          dev
dev-php                  Install PHP (see: https://php.net)                                                        dev
dotfiles                 Installs dotfiles-dotfiles, bin-folder. On MacOS: additionally installs dotfiles-vscode   group
editors                  Installs all editor-* targets                                                             group
tools                    Installs all tool-* targets. On MacOS: additionally install tool-brew                     group
devs                     Installs PHP, Go, NodeJS                                                                  group
all                      Installs all groups                                                                       group
clean-dotfiles-dotfiles  Uninstalls dotfiles
clean-dotfiles-vscode    Uninstalls VS Code settings
clean                    Uninstalls dotfiles and VS Code settings
```

# Links
- [A lot of tweaks for MacOS GUI and many more!](https://github.com/mathiasbynens/dotfiles/blob/master/.macos)
