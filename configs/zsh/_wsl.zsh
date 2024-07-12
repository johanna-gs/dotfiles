#!/usr/bin/env zsh

# Set Windows display for WSL
# export DISPLAY=':0.0'
# export LIBGL_ALWAYS_INDIRECT=1
# export GDK_BACKEND=x11

# # Oracle Tools
# export PATH=$PATH:$HOME/.local/lib/oracle/instantclient_19_18
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.local/lib/oracle/instantclient_19_18
# export ORACLE_HOME=$HOME/.local/lib/oracle/instantclient_19_18
# export TNS_ADMIN=~/tnsadmin

# # OCI
# export OCI_CLI_SUPPRESS_FILE_PERMISSIONS_WARNING=True

eval $(keychain --eval --agents ssh id_rsa)

# https://www.reddit.com/r/zsh/comments/sbt9zn/annoying_problem_with_starship_zsh_and_vimode/
zle -N zle-line-init
zle -N zle-keymap-select

# if [ -d "/home/linuxbrew/.linuxbrew" ]; then
#   export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
# fi
