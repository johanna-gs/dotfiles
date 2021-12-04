# .zshrc

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

# Load the oh-my-zsh's library
# source $DOTFILES/antigen/antigen.zsh
# antigen use oh-my-zsh

# Load the Antibody plugin manager for zsh.
source <(antibody init)

# Setup required env var for oh-my-zsh plugins
export ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"

antibody bundle robbyrussell/oh-my-zsh
antibody bundle robbyrussell/oh-my-zsh path:plugins/cp
antibody bundle robbyrussell/oh-my-zsh path:plugins/docker
antibody bundle robbyrussell/oh-my-zsh path:plugins/docker-compose
antibody bundle robbyrussell/oh-my-zsh path:plugins/git
antibody bundle robbyrussell/oh-my-zsh path:plugins/gpg-agent
antibody bundle robbyrussell/oh-my-zsh path:plugins/httpie
antibody bundle robbyrussell/oh-my-zsh path:plugins/nmap
antibody bundle robbyrussell/oh-my-zsh path:plugins/npm
antibody bundle robbyrussell/oh-my-zsh path:plugins/z

# Other bundles
antibody bundle jonmosco/kube-ps1
antibody bundle zsh-users/zsh-autosuggestions

# This needs to be the last bundle.
antibody bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
# antibody bundle robbyrussell/oh-my-zsh path:themes/robbyrussell.zsh-theme
antibody bundle dracula/zsh

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

export ANDROID_HOME="$HOME/Android/Sdk/"

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
export ARTISAN_OPEN_ON_MAKE_EDITOR='nvr'
export FZF_DEFAULT_COMMAND='ag -u -g ""'

unsetopt sharehistory

# }}}

# Interactive shell startup scripts {{{
# ==============================================================================

if [[ $- == *i* && $0 == '/bin/zsh' ]]; then
    ~/.dotfiles/scripts/login.sh
fi

# }}}

[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases
[ -f ~/.zsh_functions ] && source ~/.zsh_functions
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
