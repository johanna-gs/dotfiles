# .zshrc

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Path to your dotfiles.
export DOTFILES=$HOME/.dotfiles

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=./vendor/bin:$PATH
export PATH=~/.bin:$PATH
export PATH=/opt:$PATH

export LANG='en_GB.UTF-8'
export LC_ALL='en_GB.UTF-8'

# ~/.antigen
source "$DOTFILES/antigen/antigen.zsh"

antigen init ~/.antigenrc

# Configuration {{{
# ==============================================================================

HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

typeset -U path cdpath fpath

# Vim mode
bindkey -v
export KEYTIMEOUT=1

# Kitty bindings
bindkey "\e[1;3D" backward-word # ⌥←
bindkey "\e[1;3C" forward-word # ⌥→

export GIT_EDITOR=vim

path=(
    $HOME/.local/bin
    $HOME/.bin
    $HOME/bin
    $HOME/.composer/vendor/bin
    $HOME/.go/bin
    ./vendor/bin
    ${ANDROID_HOME}tools/
    ${ANDROID_HOME}platform-tools/
    $path
)

setopt auto_cd
cdpath=(
    $HOME/Code
)

zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %d
zstyle ':completion:*:descriptions' format %B%d%b
zstyle ':completion:*:complete:(cd|pushd):*' tag-order \
    'local-directories named-directories'

export EDITOR='vim'
export NVIM_LISTEN_ADDRESS='/tmp/nvimsocket'

unsetopt sharehistory

# Open vim with z argument
v() {
    if [ -n "$1" ]; then
    z $1
    fi

    nvim
}

open () {
    xdg-open $* > /dev/null 2>&1
}

if (( $+commands[tag] )); then
    tag() { command tag "$@"; source ${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null }
    alias ag=tag
fi

# }}}

# Prompt {{{
# ==============================================================================

source $HOME/.antigen/bundles/jonmosco/kube-ps1/kube-ps1.sh

prompt_kube_ps1() { echo -n $(kube_ps1); }
get_cluster_short() { if [[ "$1" =~ ^arn:aws:eks ]]; then echo "$1" | rev | cut -d'/' -f 1 | rev; fi; }

KUBE_PS1_CLUSTER_FUNCTION=get_cluster_short
KUBE_PS1_SYMBOL_COLOR=white
KUBE_PS1_CTX_COLOR=red
KUBE_PS1_NS_COLOR=cyan
KUBE_PS1_BG_COLOR=null
KUBE_PS1_PREFIX=" "
KUBE_PS1_SEPARATOR=""
KUBE_PS1_SUFFIX=" "
KUBE_PS1_SYMBOL_USE_IMG=true
PROMPT='$(kube_ps1)'$PROMPT
PROMPT_EOL_MARK=''

# if [[ $COLORTERM = gnome-* && $TERM = xterm ]]  && infocmp gnome-256color >/dev/null 2>&1; then export TERM=gnome-256color
# elif infocmp xterm-256color >/dev/null 2>&1; then export TERM=xterm-256color
# fi

# if tput setaf 1 &> /dev/null; then
#     tput sgr0
#     if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
#       MAGENTA=$(tput setaf 9)
#       ORANGE=$(tput setaf 172)
#       GREEN=$(tput setaf 190)
#       PURPLE=$(tput setaf 141)
#       WHITE=$(tput setaf 256)
#     else
#       MAGENTA=$(tput setaf 5)
#       ORANGE=$(tput setaf 4)
#       GREEN=$(tput setaf 2)
#       PURPLE=$(tput setaf 1)
#       WHITE=$(tput setaf 7)
#     fi
#     BOLD=$(tput bold)
#     RESET=$(tput sgr0)
# else
#     MAGENTA="\033[1;31m"
#     ORANGE="\033[1;33m"
#     GREEN="\033[1;32m"
#     PURPLE="\033[1;35m"
#     WHITE="\033[1;37m"
#     BOLD=""
#     RESET="\033[m"
# fi

# parse_git_dirty () {
#   [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
# }
# parse_git_branch () {
#   git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
# }

# PS1="\[${BOLD}${MAGENTA}\]\u \[$WHITE\]at \[$ORANGE\]\h \[$WHITE\]in \[$GREEN\]\w\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$PURPLE\]\$(parse_git_branch)\[$WHITE\]\n\$ \[$RESET\]"



# if dircolors >/dev/null 2>&1; then
#     eval $(dircolors -b ~/.dircolors)
# fi

# reset=$(tput sgr0)
# black=$(tput setaf 0)
# red=$(tput setaf 1)
# green=$(tput setaf 2)
# yellow=$(tput setaf 2)
# blue=$(tput setaf 4)
# magenta=$(tput setaf 5)
# cyan=$(tput setaf 6)
# white=$(tput setaf 7)
# brightblack=$(tput setaf 8)
# brightred=$(tput setaf 9)
# brightgreen=$(tput setaf 10)
# brightyellow=$(tput setaf 11)
# brightblue=$(tput setaf 12)
# brightmagenta=$(tput setaf 13)
# brightcyan=$(tput setaf 14)
# brightwhite=$(tput setaf 15)


# # Prompt
# if [[ "$USER" == "root" ]]; then
#     prompt_col_1=$brightred
#     prompt_col_2=$red
# elif [[ "$SSH_TTY" ]]; then
#     prompt_col_1=$brightgreen
#     prompt_col_2=$green
# else
#     prompt_col_1=$brightblue
#     prompt_col_2=$blue
# fi

# PS1='${reset}${prompt_col_1}%u[$reset]\@[$prompt_col_2\]\h\[$prompt_col_1\]:\W'

# if [ -f ~/.git-prompt.sh ]; then
#     source ~/.git-prompt.sh
#     export PS1+='\[$prompt_col_2\]$(__git_ps1 "(%s)")'
# fi

# PS1+='\[$reset\]\n\$'
# export PS1


# PROMPT='%T %B%~%b $ '

# }}}

# Interactive shell startup scripts {{{
# ==============================================================================

# if [[ $- == *i* && $0 == '/bin/zsh' ]]; then
#     ~/.dotfiles/scripts/login.sh
# fi  

# }}}

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8'

# In order for gpg to find gpg-agent, gpg-agent must be running, and there must be an env
# variable pointing GPG to the gpg-agent socket. This little script, which must be sourced
# in your shell's init script (ie, .bash_profile, .zshrc, whatever), will either start
# gpg-agent or set up the GPG_AGENT_INFO variable if it's already running.
if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
    source ~/.gnupg/.gpg-agent-info
    export GPG_AGENT_INFO
fi

export GPG_TTY=$(tty) # https://stackoverflow.com/questions/41052538/git-error-gpg-failed-to-sign-data/41054093

[ -f ~/.zsh_envs ] && source ~/.zsh_envs
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases
[ -f ~/.zsh_functions ] && source ~/.zsh_functions
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh ||  echo "⚠️  Failed to load powerlevel10k ⚠️"

# # Gradle Setup
export GRADLE_HOME=$(which gradle)

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh" || echo "⚠️  Failed to load sdkman ⚠️"
