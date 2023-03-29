#!/usr/bin/env bash

echo "Installing Visual Studio code extensions and config."

code -v >/dev/null
if [[ $? -eq 0 ]]; then
    read -r -p "Do you want to install VSC extensions? [y|N] " configresponse
    if [[ $configresponse =~ ^(y|yes|Y) ]]; then
        ok "Installing extensions please wait..."
        code --install-extensions hashicorp.terraform

        ok "Extensions for VSC have been installed. Please restart your VSC."
    else
        ok "Skipping extension install."
    fi
else
    error "It looks like the command 'code' isn't accessible."
    error "Please make sure you have Visual Studio Code installed"
    error "And that you executed this procedure: https://code.visualstudio.com/docs/setup/mac"
fi
