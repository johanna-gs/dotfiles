#!/usr/bin/env zsh

alias goto="go_to_repo"
go_to_repo() {
  local selected
  selected=$(ls -1 ~/github | \
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
