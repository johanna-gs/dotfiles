#!/usr/bin/env zsh

# # ALIAS COMMANDS
# type exa >/dev/null 2>&1 && alias ls="exa --icons --group-directories-first"
# type exa >/dev/null 2>&1 && alias ll="exa --icons --group-directories-first -l" || alias ll="ls -l"
# type exa >/dev/null 2>&1 && alias lla="ll -la"

# basic terminal aliases
alias ll="eza -l"
alias la="eza -l -a"
alias c="clear"
alias grep='grep --color'
alias cdg="cd ~/github"

# git shortcuts
alias gcl="git clone"
alias gb="git checkout -b"
alias gc="git commit -m"
alias gp="git_push_with_pr"
alias gcm="git checkout main"
alias g="git pull"
alias gs="git stash"
alias gsp="git stash pop"
alias gitkillbranches="git branch | grep -v "main" | xargs git branch -D"

# gh-dxp shortcuts
alias gdp="gh dxp pr create -b"
alias gdm="gh dxp pr merge -y"
alias gdu="gh extension upgrade dxp --force"

# quick-access to the reload-script in functions.zsh
alias rl="reload"

# goto functionality (ish)
alias gd="cd ~/dotfiles"
alias tf="terraform"

# kubernetes aliases
alias k="kubectl"

alias kg="k get"
alias kgp="kg pods"
alias kgs="kg svc"

alias kd="k describe"
alias kdp="kd pods"
alias kds="kd service"

alias kpf="k port-forward"
alias kl="k logs"

# kubernetes plugin shortcuts
alias kx="k ctx"
alias kn="k ns"

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

# launchers
alias ij="~/.local/share/JetBrains/Toolbox/scripts/idea . >/dev/null 2>&1 &"
alias pych="~/.local/share/JetBrains/Toolbox/scripts/pycharm . >/dev/null 2>&1 &"
alias mvn8="JAVA_HOME=~/.sdkman/candidates/java/8.0.302-open && mvn"
alias gradlew8="JAVA_HOME=~/.sdkman/candidates/java/8.0.302-open && ./gradlew"
alias k6="snap run k6"
alias tcg="mvn teamcity-configs:generate"

alias bcv='gh api repos/elhub/devxp-build-configuration/tags | jq -r '\''.[0].name'\'
alias gcv='get_component_version'
