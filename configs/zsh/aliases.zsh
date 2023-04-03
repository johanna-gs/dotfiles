#!/usr/bin/env zsh

# ALIAS COMMANDS
type exa >/dev/null 2>&1 && alias ls="exa --icons --group-directories-first"
type exa >/dev/null 2>&1 && alias ll="exa --icons --group-directories-first -l" || alias ll="ls -l"
type exa >/dev/null 2>&1 && alias lla="ll -la"

alias rl="reload"

alias grep='grep --color'

# goto functionality (ish)
alias gd="cd ~/dotfiles"
alias gw="cd ~/workspace"
alias gp="cd ~/privatespace"
