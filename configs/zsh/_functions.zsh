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
    curl -fsSL https://github.com/johanna-gs/dotfiles/configs/zsh/scripts/install-toolbox.sh | bash

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

git_push_with_pr() {
  local tmpfile=$(mktemp)
  trap 'rm -f "$tmpfile"' EXIT
  git push 2>&1 | tee "$tmpfile"
  local rc=${pipestatus[1]}
  if grep -qiE 'create a pull request|github.com/.*/pull/new/' "$tmpfile"; then
    gh pr create --fill && gh pr view --web
  fi
  return $rc
}

authenticate_to_github() {
    local token_file="$HOME/.github_token"
    local username="$(whoami)"

    if ! command_exists gh; then
      echo "Error: GitHub CLI (gh) is not installed. Please install it first."
      return 1
    fi

    # Check if token file exists
    if [[ ! -f "$token_file" ]]; then
        echo "Error: GitHub token file not found at $token_file"
        echo "Create the file with: echo 'your_github_token' > $token_file && chmod 600 $token_file"
        return 1
    fi

    # Read token from file
    local token=$(tr -d '\n\r' < "$token_file" 2>/dev/null)
    if [[ -z "$token" ]]; then
        echo "Error: Could not read token from $token_file or file is empty"
        return 1
    fi

    # Check if already authenticated
    if gh auth status &>/dev/null 2>&1; then
        echo "🐈 Already authenticated with GitHub CLI"
        return 0
    fi

    # Create gh config directory
    mkdir -p ~/.config/gh

    # Create hosts.yml with authentication config
    cat > ~/.config/gh/hosts.yml << EOF
github.com:
    oauth_token: $token
    user: $username
    git_protocol: https
EOF

    # Secure the config file
    chmod 600 ~/.config/gh/hosts.yml

    # Setup Git integration
    if gh auth setup-git &>/dev/null; then
        echo "✅ GitHub CLI authentication configured successfully"
        echo "✅ Git integration setup complete"
    else
        echo "❌ Warning: Git integration setup failed, but auth should still work"
    fi

    # Verify authentication
    if gh auth status &>/dev/null 2>&1; then
        echo "✅ Authentication verified - logged in as $(gh api user --jq .login)"
    else
        echo "❌ Authentication setup failed"
        return 1
    fi
}

get_component_version() {
  local repo_name="$1"
  gh api "repos/elhub/${repo_name}/tags" | jq -r '.[0].name'
}
