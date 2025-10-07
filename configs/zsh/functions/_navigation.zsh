#!/usr/bin/env zsh

alias goto="gotorepo"
gotorepo() {
  local selected
  selected=$(find ~/github \
    -mindepth 1 \
    -maxdepth 1 \
    -type d \
    -exec basename {} \; | \
    fzf \
      --height 40% \
      --reverse \
      --border \
      --preview 'ls -AF --color=always ~/github/{}' \
      --preview-window=right:50%)

  if [[ -n $selected ]]; then
    cd ~/github/"$selected" || return 1
  fi
}
