#!/usr/bin/env zsh

eval $(keychain --eval --agents ssh github)

# https://www.reddit.com/r/zsh/comments/sbt9zn/annoying_problem_with_starship_zsh_and_vimode/
zle -N zle-line-init
zle -N zle-keymap-select
