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
dotfiles-claude          Merge Claude Code hooks into ~/.claude/settings.json (needs jq)                           dotfiles
test-claude-guard        Run the scenario tests of the Claude spec/plan guard hook                                 dotfiles
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
dotfiles                 Installs dotfiles-dotfiles, dotfiles-claude, bin-folder. On MacOS: additionally installs dotfiles-vscode   group
editors                  Installs all editor-* targets                                                             group
tools                    Installs all tool-* targets. On MacOS: additionally install tool-brew                     group
devs                     Installs PHP, Go, NodeJS                                                                  group
all                      Installs all groups                                                                       group
clean-dotfiles-dotfiles  Uninstalls dotfiles
clean-dotfiles-vscode    Uninstalls VS Code settings
clean                    Uninstalls dotfiles and VS Code settings
```

## Claude Code

Global Claude Code configuration, shared by all projects:

- `dotfiles/claude/CLAUDE.md` — personal instructions.
- `dotfiles/claude/agents/` — subagent roles, each with its own model and effort:
  `spec-writer`, `planner`, `developer`, `reviewer`, `final-reviewer`,
  `researcher`, `data-gatherer`.
- `dotfiles/claude/skills/` — skills loaded only when a task needs them, so
  their rules do not take context in every session: `presentations`.
- `dotfiles/claude/hooks/spec-guard.py` — a `PreToolUse` hook: specs
  (`docs/superpowers/specs/`) are written only by `spec-writer` (Fable 5.2,
  effort high), plans (`docs/superpowers/plans/`) only by `planner`
  (Opus 5.5, effort high).

`make dotfiles-dotfiles` symlinks these into `~/.claude/` like every other
dotfile. `~/.claude/settings.json` is not symlinked, because Claude Code and
plugins rewrite it. `make dotfiles-claude` merges the hook from
`claude/settings.hooks.json` into it instead. The merge is idempotent and
keeps every other setting.

The hook stops Claude from editing `spec-guard.py`, `spec-writer.md` and
`planner.md`, through `~/.claude` and in this repository alike. Change those
files by hand, then run `make test-claude-guard`: scenario tests in
`claude/tests/` run the hook against a temporary home and never touch the
real `~/.claude`.

# Links
- [A lot of tweaks for MacOS GUI and many more!](https://github.com/mathiasbynens/dotfiles/blob/master/.macos)
