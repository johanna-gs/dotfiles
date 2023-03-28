#!/usr/bin/env zsh

# ALIAS COMMANDS
type exa >/dev/null 2>&1 && alias ls="exa --icons --group-directories-first"
type exa >/dev/null 2>&1 && alias ll="exa --icons --group-directories-first -l" || alias ll="ls -l"
type exa >/dev/null 2>&1 && alias lla="ll -la"

alias rl="reload"

alias g="goto"
alias grep='grep --color'
