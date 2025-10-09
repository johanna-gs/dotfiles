#!/usr/bin/env zsh

# basic terminal aliases
alias ll="eza -l"
alias la="eza -l -a"
alias c="clear"
alias grep='grep --color'

# moving around
alias cdg="cd ~/github"
alias cdd="cd ~/dotfiles"

# git shortcuts
alias g="git pull --prune"
alias gb="git checkout -b"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git_push_with_pr"
alias gcl="git clone"
alias gcm="git checkout main"
alias gs="git stash"
alias gsp="git stash pop"

# git version commands
alias bcv='gh api repos/elhub/devxp-build-configuration/tags | jq -r '\''.[0].name'\'
alias gcv='get_component_version'

# gh-dxp shortcuts
alias gdp="gh dxp pr create -b"
alias gdm="gh dxp pr merge -y"
alias gdu="gh extension upgrade dxp --force"

# kubernetes aliases
alias k="kubectl"

alias kg="kubectl_get"
alias kgp="k get pods"

alias kd="kubectl_describe"

alias kpf="kubectl_port_forward"
alias kl="kubectl_logs"

# kubernetes plugin shortcuts
alias kx="k ctx"
alias kn="k ns"

# kubectl function aliases
alias kex="kubectl_exec_into_pod"
alias kps="kubectl_psql_start"

# launchers
alias ij="~/.local/share/JetBrains/Toolbox/scripts/idea . >/dev/null 2>&1 &"
alias idea="/mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')/AppData/Local/JetBrains/Toolbox/scripts/idea . >/dev/null 2>&1 &"
alias gl="~/.local/share/JetBrains/Toolbox/scripts/goland . >/dev/null 2>&1 &"
alias pych="~/.local/share/JetBrains/Toolbox/scripts/pycharm . >/dev/null 2>&1 &"
alias mvn8="JAVA_HOME=~/.sdkman/candidates/java/8.0.302-open && mvn"
alias gradlew8="JAVA_HOME=~/.sdkman/candidates/java/8.0.302-open && ./gradlew"
alias tcg="mvn teamcity-configs:generate"
