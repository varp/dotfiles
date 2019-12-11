# Dotfiles
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
