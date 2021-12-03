#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

brew tap "homebrew/bundle"
brew tap "homebrew/cask"
brew tap "homebrew/cask-versions"
brew tap "homebrew/cask-fonts"
brew tap "homebrew/core"
brew tap "homebrew/services"

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
softwareupdate --all --install --force
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed
# Install a modern version of Bash.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
    echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells
    chsh -s "${BREW_PREFIX}/bin/bash"
fi

# Install `wget` with IRI support.
brew install wget --with-iri

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Install more recent versions of some macOS tools.
brew install vim
brew install grep
brew install openssh
brew install screen
brew install php
brew install gmp

# Install other useful binaries.
brew install "antibody"
brew install "awscli"
brew install "fx"
brew install "git"
brew install "gnu-sed"
brew install "go-task/tap/go-task"
brew install "httpie"
brew install "helm"
brew install "jq"
brew install "kubernetes-cli"
brew install "kube-ps1"
brew install "mas" # macOS-only
brew install "yq"
brew install "zsh"
brew install "zsh-completions"
brew install "zsh-syntax-highlighting"

# Install casks
brew install --cask "alfred"
brew install --cask "firefox-developer-edition"
brew install --cask "font-fira-code"
brew install --cask "font-jetbrains-mono"
brew install --cask "karabiner-elements"
brew install --cask "kitty"
brew install --cask "visualvm"
brew install --cask "visual-studio-code-insiders"

# Remove outdated versions from the cellar.
brew cleanup

### mac app store
mas "keynote", id: 409183694
