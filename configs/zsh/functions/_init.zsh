#!/usr/bin/env zsh

# These functions are intended to run during WSL initiation (ideally just once)

install_toolbox() {
    sudo apt install libxtst6 libxi6 x11-apps libnss3-dev libasound2-dev libfuse2 -y
    curl -fsSL https://raw.githubusercontent.com/johanna-gs/dotfiles/refs/heads/main/configs/zsh/scripts/install-toolbox.sh | bash

    local retVal=$?

    if [ $retVal -ne 0 ]; then
      echo "❌ jetbrains-toolbox could not be installed"
    else
      echo "✅ jetbrains-toolbox installed"
    fi
}

install_nerdFont() {
    curl -L -o JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip \
        && sudo unzip JetBrainsMono.zip JetBrainsMonoNerdFont-Regular.ttf -d /usr/local/share/fonts \
        && rm JetBrainsMono.zip \
        && sudo fc-cache -fv
}

create_wayland_symlink() {
  if [ "$(stat -c %a /mnt/wslg/runtime-dir)" -ne 755 ]; then
    sudo chmod 755 /mnt/wslg/runtime-dir
  fi

  ln -sf  /mnt/wslg/runtime-dir/wayland-* $XDG_RUNTIME_DIR/
}
