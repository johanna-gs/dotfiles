#### ---- fast-syntax-highlighting ------------------------
[ -f ~/dotfiles/configs/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ] && source ~/dotfiles/configs/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

#### ---- zsh-autosuggestions ------------------------
[ -f ~/dotfiles/configs/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/dotfiles/configs/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

#autosuggestion highlighting
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

#fzf keybindings
source <(fzf --zsh)

# oh-my-zsh like cd completion
source ~/dotfiles/configs/zsh/plugins/completion.zsh
