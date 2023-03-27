#!/bin/zsh

# Custom aliases
[ -f ~/.zsh/aliases.zsh ] && source ~/.zsh/aliases.zsh

# Custom functions
[ -f ~/.zsh/functions.zsh ] && source ~/.zsh/functions.zsh

# Other zsh-configs
[ -f ~/.zsh/starship.zsh ] && source ~/.zsh/starship.zsh

# WSL specific things
if grep --quiet microsoft /proc/version 2>/dev/null; then
    # Set Windows display for WSL
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')':0.0'
    export LIBGL_ALWAYS_INDIRECT=1
fi

# Preferred editor for local and remote sessions
export EDITOR='vim'

# Go
if [[ -d /usr/local/go/bin ]]; then
    export PATH=$PATH:/usr/local/go/bin
    export PATH=$PATH:$(go env GOPATH)/bin
fi

## History command configuration
HISTSIZE=5000                 # How many lines of history to keep in memory
HISTFILE=~/.zsh_history       # Where to save history to disk
SAVEHIST=5000                 # Number of history entries to save to disk
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# Starship
eval "$(starship init zsh)"

#autoload -U +X bashcompinit && bashcompinit
#complete -o nospace -C /home/anders.kirkeby/.local/lib/vault/1.7.0/vault vault
