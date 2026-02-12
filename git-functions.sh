#!/usr/bin/env bash

# gclone - Clone a git repository to ~/git/domain/org/repo structure
gclone() {
    if [ -z "$1" ]; then
        echo "Usage: gclone <git-url>"
        echo "Examples:"
        echo "  gclone git@github.com:user/repo.git"
        echo "  gclone https://github.com/user/repo.git"
        return 1
    fi

    local url="$1"
    local domain org_and_repo

    # Parse SSH-style URL: git@domain:org/repo.git
    if [[ "$url" =~ ^git@([^:]+):(.+)$ ]]; then
        domain="${BASH_REMATCH[1]}"
        org_and_repo="${BASH_REMATCH[2]}"
    # Parse HTTPS-style URL: https://domain/org/repo.git
    elif [[ "$url" =~ ^https?://([^/]+)/(.+)$ ]]; then
        domain="${BASH_REMATCH[1]}"
        org_and_repo="${BASH_REMATCH[2]}"
    else
        echo "Error: Unable to parse git URL: $url"
        return 1
    fi

    # Remove .git suffix if present
    org_and_repo="${org_and_repo%.git}"

    # Build target directory path
    local target_dir="$HOME/git/$domain/$org_and_repo"

    # Check if directory already exists
    if [ -d "$target_dir" ]; then
        echo "Repository already exists at: $target_dir"
        cd "$target_dir" || return 1
        return 0
    fi

    # Create parent directories
    local parent_dir="${target_dir%/*}"
    mkdir -p "$parent_dir"

    # Clone the repository
    echo "Cloning $url to $target_dir..."
    if git clone "$url" "$target_dir"; then
        echo "Successfully cloned to: $target_dir"
        cd "$target_dir" || return 1
    else
        echo "Error: Failed to clone repository"
        return 1
    fi
}

# gt - Fuzzy-find and navigate to a git repository under ~/git
gt() {
    # Check if fzf is installed
    if ! command -v fzf &> /dev/null; then
        echo "Error: fzf is not installed. Please install fzf to use this command."
        return 1
    fi

    local git_base="$HOME/git"

    # Check if git base directory exists
    if [ ! -d "$git_base" ]; then
        echo "Error: $git_base directory does not exist"
        return 1
    fi

    # Find all git repositories (directories containing .git)
    # Remove the git_base prefix and .git suffix for cleaner display
    local selected
    selected=$(find "$git_base" -type d -name ".git" 2>/dev/null | \
        sed "s|$git_base/||; s|/.git$||" | \
        fzf --height 40% --reverse --prompt "Select repository: ")

    # Check if user cancelled (empty selection)
    if [ -z "$selected" ]; then
        return 0
    fi

    # Change to the selected directory
    local target_dir="$git_base/$selected"
    if [ -d "$target_dir" ]; then
        cd "$target_dir" || return 1
        echo "Changed to: $target_dir"
    else
        echo "Error: Directory not found: $target_dir"
        return 1
    fi
}


alias gc="git commit"
alias gs="git status"
alias gb="git branch"
alias gd="git diff"

function gcb {
    if [ -z "${1}" ]; then
        git checkout "$(git for-each-ref --format='%(refname:short)' refs/heads/ | fzy)"
    else
        git checkout "${1}"
    fi
}

# Create a new local branch
function fb() {
  git pull
  git checkout -b "$1"
}

function pushb() {
    git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)"
}

function mergeb() {
    BRANCH=$(git branch --show-current)
    git checkout -
    git pull
    git branch -D "$BRANCH"
}

# Delete a local branch and also delete it from origin
function gitd() {
  echo "Do you really want to delete branch $1 everywhere?"
    select yn in "Yes" "No"; do
    case $yn in
      Yes ) git branch -D "$1" && git push origin --delete "$1"; break;;
      No ) exit;;
  esac
    done
}
