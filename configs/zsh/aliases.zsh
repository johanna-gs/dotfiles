#!/usr/bin/env zsh

# ALIAS COMMANDS
type exa >/dev/null 2>&1 && alias ls="exa --icons --group-directories-first"
type exa >/dev/null 2>&1 && alias ll="exa --icons --group-directories-first -l" || alias ll="ls -l"
type exa >/dev/null 2>&1 && alias lla="ll -la"

# quick-access to the reload-script in functions.zsh
alias rl="reload"

alias grep='grep --color'

# goto functionality (ish)
alias gd="cd ~/dotfiles"
alias gw="cd ~/workspace"
alias gp="cd ~/privatespace"

alias tf="terraform"

# kubernetes aliases
alias k="kubectl"

alias kg="k get"
alias kgp="kg pods"
alias kgs="kg svc"

alias kpf="k port-forward"
alias kl="k logs"

# function aliases
alias kex="kubectl_exec_into_pod"
alias kps="kubectl_psql_start"

# docker aliases
alias dps="docker ps -a"
alias dl="docker logs"
