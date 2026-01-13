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

  gh api "repos/elhub/${repo_name}/tags" | \
    jq -r '.[0] | .name + " " + .commit.sha' | \
    while read -r tag_name commit_sha; do
      commit_date=$(gh api "repos/elhub/${repo_name}/commits/${commit_sha}" | \
                    jq -r '.commit.committer.date' | \
                    xargs -I {} date -d {} "+%Y-%m-%d %H:%M:%S")
      echo "${tag_name} | ${commit_date}"
    done
}

alias gpc=pr_checkout
pr_checkout() {
  local pr_number

  # If argument provided, use it directly
  if [[ -n "$1" ]]; then
    pr_number="$1"
  else
    # Use fzf to select from PR list
    pr_number=$(gh pr list |
                awk -F'\t' '{
                  # Truncate title to 50 characters
                  title = substr($2, 1, 50)
                  if (length($2) > 50) title = title "..."

                  # Truncate branch to 20 characters
                  branch = substr($3, 1, 20)
                  if (length($3) > 20) branch = branch "..."

                  printf "%-8s %-55s %-25s %-10s %s\n", $1, title, branch, $4, $5
                }' |
                fzf --prompt="Select PR: " --height=~40% --border |
                awk '{print $1}' |
                sed 's/#//')

    # Exit if no selection made
    [[ -z "$pr_number" ]] && return 1
  fi

  gh pr checkout "$pr_number"
}

alias gclean=git-cleanup
git-cleanup() {
  # Get the current branch
  local current_branch=$(git branch --show-current)

  # Get all local branches except the current one
  local branches=$(git branch | grep -v "^\*" | sed 's/^[* ]*//')

  # Prune remote branches
  echo "Pruning remote branches..."
  git remote prune origin
  echo ""

  if [[ -z "$branches" ]]; then
    echo "No local branches to delete (only current branch exists)"
    return 0
  fi

  echo "The following branches will be deleted:"
  echo "$branches"
  echo ""
  read "response?Continue? (y/n) "

  if [[ "$response" =~ ^[Yy]$ ]]; then
    # Delete each branch
    echo "$branches" | while read branch; do
      if [[ -n "$branch" ]]; then
        git branch -D "$branch"
      fi
    done

    echo "Cleanup complete!"
  else
    echo "Cleanup cancelled"
  fi
}
