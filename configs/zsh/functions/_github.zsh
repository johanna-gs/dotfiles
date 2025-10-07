#!/usr/bin/env zsh

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
  local repo_name

  # If argument provided, use it directly
  if [[ -n "$1" ]]; then
    repo_name="$1"
  else
    # Use fzf to select from directories in ~/github
    repo_name=$(ls -1 "$HOME/github" |
                fzf --prompt="Select repo: " --height=40% --border)

    # Exit if no selection made
    [[ -z "$repo_name" ]] && return 1
  fi

  gh api "repos/elhub/${repo_name}/tags" | jq -r '.[0].name'
}
