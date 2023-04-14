#!/usr/bin/env zsh

RED='\033[0;32m'
NC='\033[0m' # No Color

functions reload() {
    [ -f  $HOME/.zshenv ] && source $HOME/.zshenv && clear
    source $HOME/.zshrc && echo "${RED}󰑌 .zshrc reloaded${NC}"
}
