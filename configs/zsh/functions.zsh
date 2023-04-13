#!/usr/bin/env zsh

functions reload() {
    [ -f  $HOME/.zshenv ] && source $HOME/.zshenv && clear
    source $HOME/.zshrc && echo "♻️  .zshrc reloaded"
}
