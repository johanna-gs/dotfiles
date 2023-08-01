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

# kubectl function aliases
alias kex="kubectl_exec_into_pod"
alias kps="kubectl_psql_start"

# docker aliases
alias dps='docker ps -a --format "table {{.Names}}\t{{.Status}}" | (read -r; printf "%s\n" "$REPLY"; sort -k 1 )'
alias dl="docker logs"

# docker function aliases
alias dex="docker_exec_into_container"

# wsl clock adjustment
alias fc="fix_wsl_clock"

# arcanist aliases
alias diff="arc diff --reviewers '#elhub_data-sharing'"
alias land="arc land && git checkout master && git pull"
