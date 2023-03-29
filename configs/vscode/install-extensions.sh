#!/usr/bin/env bash

echo "Installing Visual Studio code extensions and config."

code -v >/dev/null
if [[ $? -eq 0 ]]; then
    echo "Installing extensions please wait..."
    code --install-extension hashicorp.terraform
    code --install-extension dracula-theme.theme-dracula
    code --install-extension foxundermoon.shell-format

    echo "Extensions for VSC have been installed. Please restart your VSC."
else
    echo "It looks like the command 'code' isn't accessible."
    echo "Please make sure you have Visual Studio Code installed"
    echo "And that you executed this procedure: https://code.visualstudio.com/docs/setup/mac"
fi
