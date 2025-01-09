#!/usr/bin/env zsh

RED='\033[0;32m'
NC='\033[0m' # No Color

# Utility functions
command_exists() {
  command -v "$@" >/dev/null 2>&1
}

reload() {
    if [ -f  $HOME/.zshenv ]; then
        source $HOME/.zshrc
        clear
        echo "${RED}󰑌 .zshrc reloaded${NC}"
    fi
}

kubectl_exec_into_pod() {
    if [ $# -eq 0 ]; then
        echo "No pod name supplied in arguments"
        return
    fi
    echo "Execing into pod $1";
    kubectl exec --stdin --tty $1 -- /bin/bash
}


kubectl_psql_start() {
    PGPASSWORD_POSTGRES=$(kubectl get secret --namespace default timescaledb-credentials -o jsonpath="{.data.PATRONI_SUPERUSER_PASSWORD}" | base64 --decode)

    kubectl run -i --tty --rm psql --image=postgres \
        --env "PGPASSWORD=$PGPASSWORD_POSTGRES" \
        --command -- psql -U postgres -h timescaledb.default.svc.cluster.local postgres
}

docker_exec_into_container() {
    if [ $# -eq 0 ]; then
        echo "No container name supplied in arguments"
        return
    fi
    echo "Execing into container $1";
    docker exec -i -t $1 /bin/bash
}

install_toolbox() {
  sudo apt install libxtst6 libxi6 x11-apps libnss3-dev libasound2-dev libfuse2 -y
    curl -fsSL https://raw.githubusercontent.com/nagygergo/jetbrains-toolbox-install/master/jetbrains-toolbox.sh | bash

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

install_ghostty() {
  sudo apt install -y libgtk-4-dev libadwaita-1-dev git
  cd ~/dotfiles/meta/ghostty
  zig build -Doptimize=ReleaseFast
  cp -r ~/dotfiles/meta/ghostty/zig-out/bin/ghostty ~/.local/bin
  cp -r ~/dotfiles/meta/ghostty/zig-out/share/ghostty ~/.config
  curl -LO https://github.com/mkasberg/ghostty-ubuntu/releases/download/1.0.1-0-ppa2/ghostty_1.0.1-0.ppa2_amd64_24.04.deb
  sudo dpkg -i ghostty_*.deb
  rm ghostty_1.0.1-0.ppa2_amd64_24.04.deb
}