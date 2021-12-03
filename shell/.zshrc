# .zshrc

# Load the Antibody plugin manager for zsh.
source <(antibody init)

source ~/.zsh_aliases # Source some extra files
source ~/.zsh_functions

# Setup required env var for oh-my-zsh plugins
export ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"

antibody bundle robbyrussell/oh-my-zsh
antibody bundle robbyrussell/oh-my-zsh path:plugins/adb
antibody bundle robbyrussell/oh-my-zsh path:plugins/bower
antibody bundle robbyrussell/oh-my-zsh path:plugins/composer
antibody bundle robbyrussell/oh-my-zsh path:plugins/cp
antibody bundle robbyrussell/oh-my-zsh path:plugins/dnf
antibody bundle robbyrussell/oh-my-zsh path:plugins/docker
antibody bundle robbyrussell/oh-my-zsh path:plugins/docker-compose
antibody bundle robbyrussell/oh-my-zsh path:plugins/git
antibody bundle robbyrussell/oh-my-zsh path:plugins/git-flow
antibody bundle robbyrussell/oh-my-zsh path:plugins/gpg-agent
antibody bundle robbyrussell/oh-my-zsh path:plugins/gulp
antibody bundle robbyrussell/oh-my-zsh path:plugins/httpie
antibody bundle robbyrussell/oh-my-zsh path:plugins/jsontools
antibody bundle robbyrussell/oh-my-zsh path:plugins/jump
antibody bundle robbyrussell/oh-my-zsh path:plugins/nmap
antibody bundle robbyrussell/oh-my-zsh path:plugins/npm
antibody bundle robbyrussell/oh-my-zsh path:plugins/pass
antibody bundle robbyrussell/oh-my-zsh path:plugins/rsync
antibody bundle robbyrussell/oh-my-zsh path:plugins/z

# Other bundles
antibody bundle jonmosco/kube-ps1
antibody bundle zsh-users/zsh-autosuggestions

# This needs to be the last bundle.
antibody bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
# antibody bundle robbyrussell/oh-my-zsh path:themes/robbyrussell.zsh-theme
antibody bundle dracula/zsh

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
    /opt
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

# if (( $+commands[tag] )); then
#     tag() { command tag "$@"; source ${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null }
#     alias ag=tag*
# fi

export PATH=/opt/homebrew/bin:$PATH
export PATH=$HOME/bin:/usr/local/bin:$PATH

# # If you come from bash you might have to change your $PATH.

# # Path to your oh-my-zsh installation.
# export ZSH="/Users/akirkeby/.oh-my-zsh"

# # Set name of the theme to load --- if set to "random", it will
# # load a random theme each time oh-my-zsh is loaded, in which case,
# # to know which specific one was loaded, run: echo $RANDOM_THEME
# # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="agnoster"

# # Set list of themes to pick from when loading at random
# # Setting this variable when ZSH_THEME=random will cause zsh to load
# # a theme from this variable instead of looking in $ZSH/themes/
# # If set to an empty array, this variable will have no effect.
# # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# # Uncomment the following line to use case-sensitive completion.
# # CASE_SENSITIVE="true"

# # Uncomment the following line to use hyphen-insensitive completion.
# # Case-sensitive completion must be off. _ and - will be interchangeable.
# # HYPHEN_INSENSITIVE="true"

# # Uncomment the following line to disable bi-weekly auto-update checks.
# # DISABLE_AUTO_UPDATE="true"

# # Uncomment the following line to automatically update without prompting.
# # DISABLE_UPDATE_PROMPT="true"

# # Uncomment the following line to change how often to auto-update (in days).
# # export UPDATE_ZSH_DAYS=13

# # Uncomment the following line if pasting URLs and other text is messed up.
# # DISABLE_MAGIC_FUNCTIONS="true"

# # Uncomment the following line to disable colors in ls.
# # DISABLE_LS_COLORS="true"

# # Uncomment the following line to disable auto-setting terminal title.
# # DISABLE_AUTO_TITLE="true"

# # Uncomment the following line to enable command auto-correction.
# # ENABLE_CORRECTION="true"

# # Uncomment the following line to display red dots whilst waiting for completion.
# # Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# # See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# # COMPLETION_WAITING_DOTS="true"

# # Uncomment the following line if you want to disable marking untracked files
# # under VCS as dirty. This makes repository status check for large repositories
# # much, much faster.
# # DISABLE_UNTRACKED_FILES_DIRTY="true"

# # Uncomment the following line if you want to change the command execution time
# # stamp shown in the history command output.
# # You can set one of the optional three formats:
# # "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# # or set a custom format using the strftime function format specifications,
# # see 'man strftime' for details.
# # HIST_STAMPS="mm/dd/yyyy"

# # Would you like to use another custom folder than $ZSH/custom?
# # ZSH_CUSTOM=/path/to/new-custom-folder

# # Which plugins would you like to load?
# # Standard plugins can be found in $ZSH/plugins/
# # Custom plugins may be added to $ZSH_CUSTOM/plugins/
# # Example format: plugins=(rails git textmate ruby lighthouse)
# # Add wisely, as too many plugins slow down shell startup.
# plugins=(git)

# source $ZSH/oh-my-zsh.sh
# source $ZSH/custom-functions.sh

# # User configuration

export MANPATH="/usr/local/man:$MANPATH"

# # You may need to manually set your language environment
# # export LANG=en_US.UTF-8

# # Preferred editor for local and remote sessions
# # if [[ -n $SSH_CONNECTION ]]; then
# #   export EDITOR='vim'
# # else
# #   export EDITOR='mvim'
# # fi

# # Compilation flags
# # export ARCHFLAGS="-arch x86_64"

# # Set personal aliases, overriding those provided by oh-my-zsh libs,
# # plugins, and themes. Aliases can be placed here, though oh-my-zsh
# # users are encouraged to define aliases within the ZSH_CUSTOM folder.
# # For a full list of active aliases, run `alias`.
# #
# # Example aliases
# # alias zshconfig="mate ~/.zshrc"
# # alias ohmyzsh="mate ~/.oh-my-zsh"

# prompt_context() {}

# if type brew &>/dev/null; then
#     FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

#     autoload -Uz compinit
#     compinit
# fi

# alias code="code-insiders"
# alias zsh-reload="source ~/.zshrc"

# alias kx="kubectx"

# alias k="kubectl"
# alias kl="kubectl logs"
# alias kg="kubectl get"
# alias kgp="kubectl get pods --selector='!e2e-test-name'"
# alias kgd="kubectl get deployments"
# alias kgi="kubectl get ingress"
# alias kgs="kubectl get services"
# alias kgss="kubectl get secrets"
# alias kgcm="kubectl get configmaps"
# alias kgns="kubectl get namespaces"

# alias kd="kubectl describe"
# alias kdp="kubectl describe pods"
# alias kdi="kubectl describe ingress"
# alias kdd="kubectl describe deployments"
# alias kdcj="kubectl describe cronjobs"
# alias kdcm="kubectl describe configmaps"

# alias kpf="kubectl port-forward"

# complete -F __start_kubectl k

# alias pip=pip3
# alias python=python3

# alias kafka-topics=~/Ruter/kafka_2.7.0/bin/kafka-topics.sh

# alias sso-login="aws sso login --profile sso-dev-eks"

# bindkey "\e\e[D" backward-word
# bindkey "\e\e[C" forward-word

# # Use vsCode for brew formulae
# # export EDITOR="code -w"
# export EDITOR="vim"

# autoload -U +X bashcompinit && bashcompinit
# #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="/Users/akirkeby/.sdkman"
# [[ -s "/Users/akirkeby/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/akirkeby/.sdkman/bin/sdkman-init.sh"

# export GITLAB_ACCESS_TOKEN="prVZwm6gw5DM6aXATAx4"
# export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# alias intellij="open -na 'IntelliJ IDEA.app'"

if [[ $- == *i* && $0 == '/bin/zsh' ]]; then
    ~/.dotfiles/scripts/login.sh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
