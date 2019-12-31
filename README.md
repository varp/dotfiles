# Dotfiles ![](https://github.com/varp/dotfiles/workflows/test/badge.svg)
## Prequisties
    bash ./bin/taskfile-install # To install https://taskfile.dev/


## Installation

To see list of all tasks:

    ./bin/task

Install dotfiles and binfiles:
    
    ./bin/task install

Or separately:

    ./bin/task dotfiles
    ./bin/task binfiles

### Sublime Text 3
    ./bin/task sublime:settings # Install settings
    ./bin/task sublime:packagecontrol # Install package manager

### Visual Studio Code
    ./bin/task vscode:settings    # Installs vscode settings
    ./bin/task vscode:extensions  # Install vscode extensions 

### VIM
    ./bin/task vim:vundle # Install VIM's Vundle


### List of all tasks

To get list of all tasks, just run: `./bin/task`

    task: Available tasks for this project:
    * binfiles:                     Installs bin files
    * dotfiles:                     Installs dot files
    * env:node:                     Installs NodeJs env
    * env:node:install:             Installs a Node version
    * env:php:                      Installs PHP env
    * env:php:composer:             Installs PHP composer
    * env:python:                   Installs pyenv
    * env:python:install:           Installs Python 3
    * install:                      Runs tasks: binfiles, dotfiles
    * repo:ppa:php:                 Enables PPA for PHP
    * repo:rpm:php:                 Enables RPM repos for PHP
    * sublime:packagecontrol:       Installs ST3 package control
    * sublime:settings:             Installs SublimeText settings
    * tools:git:lfs:                Installs git-lfs
    * tools:lfm:                    Installs LFM
    * tools:shell:powerline-go:     Installs latest powerline-go
    * vim:vundle:                   Installs VIM's Vundle package mamager
    * vscode:extenstions:           Installs VS code extenstions
    * vscode:settings:              Installs VS Code settings

# Links
- [A lot tweaks for MacOS GUI and not!](https://github.com/mathiasbynens/dotfiles/blob/master/.macos)