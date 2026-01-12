#!/usr/bin/env zsh

alias goto="go_to_repo"
go_to_repo() {
  local selected

  # If an argument is provided, use it directly
  if [[ -n $1 ]]; then
    selected="$1"
  else
    # Otherwise, use fzf to select
    selected=$(ls -1 ~/github | \
      fzf \
        --height 40% \
        --reverse \
        --border \
        --preview 'ls -AF --color=always ~/github/{}' \
        --preview-window=right:50%)
  fi

  if [[ -n $selected ]]; then
    cd ~/github/"$selected" || return 1
  fi
}
