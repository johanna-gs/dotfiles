#!/usr/bin/env bash

set -e

unameOut=$(uname -a)
case "${unameOut}" in
*Microsoft*) OS="WSL" ;; #wls must be first since it will have Linux in the name too
*microsoft*) OS="WSL2" ;;
Linux*) OS="Linux" ;;
Darwin*) OS="Mac" ;;
CYGWIN*) OS="Cygwin" ;;
MINGW*) OS="Windows" ;;
*Msys) OS="Windows" ;;
*) OS="UNKNOWN:${unameOut}" ;;
esac

if [[ ${OS} == "Mac" ]] && sysctl -n machdep.cpu.brand_string | grep -q 'Apple M1'; then
    #Check if its an M1. This check should work even if the current processes is running under x86 emulation.
    OS="MacM1"
fi

if [[ ${OS} == "Windows" ]]; then
    echo "To run the setup guide in windows, use the .profiles/windows/setup.ps1 instead"
    exit 1
fi

echo "Running setup for $OS ⚒️"

if [[ ${OS} == "MacM1" ]] && ! xcode-select --print-path &>/dev/null; then

    # Prompt user to install the XCode Command Line Tools
    xcode-select --install &>/dev/null

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Wait until the XCode Command Line Tools are installed
    until xcode-select --print-path &>/dev/null; do
        sleep 5
    done

    print_result $? 'Install XCode Command Line Tools'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Point the `xcode-select` developer directory to
    # the appropriate directory from within `Xcode.app`
    # https://github.com/alrra/dotfiles/issues/13

    sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
    print_result $? 'Make "xcode-select" developer directory point to Xcode'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Prompt user to agree to the terms of the Xcode license
    # https://github.com/alrra/dotfiles/issues/10

    sudo xcodebuild -license
    print_result $? 'Agree with the XCode Command Line Tools licence'

fi

if test ! $(which brew); then
    echo "Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>$HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

mkdir -p ~/.gnupg # Create the gpg directory before running the installer

echo "Finished setting up your ${OS} environment 😎"
