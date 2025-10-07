#!/usr/bin/env zsh

RED='\033[0;32m'
NC='\033[0m' # No Color

alias rl="reload"
reload() {
    if [ -f  $HOME/.zshenv ]; then
        source $HOME/.zshrc
        clear
        echo "${RED}󰑌 .zshrc reloaded${NC}"
    fi
}

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

[ -f ~/.config/zsh/functions/helm.zsh ] && source ~/.config/zsh/functions/helm.zsh
[ -f ~/.config/zsh/functions/kubectl.zsh ] && source ~/.config/zsh/functions/kubectl.zsh
[ -f ~/.config/zsh/functions/init.zsh ] && source ~/.config/zsh/functions/init.zsh
[ -f ~/.config/zsh/functions/github.zsh ] && source ~/.config/zsh/functions/github.zsh
