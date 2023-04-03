#!/usr/bin/env zsh

functions reload() {
    [ -f  $HOME/.zshenv ] && source $HOME/.zshenv
    source $HOME/.zshrc && echo "♻️  .zshrc reloaded"
}
