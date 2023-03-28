#!/bin/zsh

functions reload() {
    [ -f  $HOME/.zshenv ] && source $HOME/.zshenv
    source ${ZDOTDIR:-HOME}/.zshrc && echo "♻️  .zshrc reloaded"
}
