#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

###########
# General #
###########

# Auto "cd" when entering just a path
shopt -s autocd 2>/dev/null

# Line wrap on window resize
shopt -s checkwinsize 2>/dev/null

# Case-insensitive tab completetion
bind 'set completion-ignore-case on'

# When displaying tab completion options, show just the remaining characters
bind 'set completion-prefix-display-length 2'

# Show tab completion options on the first press of TAB
bind 'set show-all-if-ambiguous on'
bind 'set show-all-if-unmodified on'

########
# Path #
########

PATH=/usr/local/bin:$PATH
PATH=~/.composer/vendor/bin:$PATH
PATH=./vendor/bin:$PATH
PATH=~/.bin:$PATH
PATH=~/Scripts:$PATH
PATH=/opt:$PATH

###########
# History #
###########

# Append to the Bash history file, rather than overwriting
shopt -s histappend 2>/dev/null

# Hide some commands from the history
#export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help";

# Entries beginning with space aren't added into history, and duplicate
# entries will be erased (leaving the most recent entry).
export HISTCONTROL="ignorespace:erasedups"

# Give history timestamps.
export HISTTIMEFORMAT="[%F %T] "

# Lots o' history.
export HISTSIZE=10000
export HISTFILESIZE=10000

if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
