# Git Repository Management Functions

Bash functions to organize and navigate git repositories in a hierarchical directory structure.

## Features

- **`gclone`**: Clone git repositories to `~/git/domain/org/repo` structure
- **`gt`**: Fuzzy-find and navigate to any cloned repository

## Installation

1. Source the functions in your shell profile (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
source /path/to/git-functions.sh
```

2. Reload your shell or run:

```bash
source ~/.bashrc  # or ~/.zshrc
```

## Requirements

- **fzf**: Required for the `gt` command. Install via:
  - macOS: `brew install fzf`
  - Linux: `sudo apt-get install fzf` or equivalent

## Usage

### `gclone` - Clone with automatic organization

Clone a repository to the hierarchical directory structure:

```bash
# SSH URL
gclone git@github.com:user/repo.git
# Clones to: ~/git/github.com/user/repo/

# HTTPS URL
gclone https://github.com/user/repo.git
# Clones to: ~/git/github.com/user/repo/

# Multi-level organizations
gclone git@gitlab.com:org/subgroup/project.git
# Clones to: ~/git/gitlab.com/org/subgroup/project/
```

The function will:
- Parse the URL to extract domain, organization, and repository name
- Create the directory structure if it doesn't exist
- Clone the repository to the appropriate location
- Change your current directory to the cloned repository

### `gt` - Navigate to repositories

Quickly navigate to any cloned repository using fuzzy-finding:

```bash
gt
```

This will:
- Search for all git repositories under `~/git/`
- Display an interactive fuzzy-finder (fzf) list
- Change to the selected repository directory

Use arrow keys or type to filter, then press Enter to select.

## Examples

```bash
# Clone a repository
$ gclone git@github.com:torvalds/linux.git
Cloning git@github.com:torvalds/linux.git to /Users/you/git/github.com/torvalds/linux...
Successfully cloned to: /Users/you/git/github.com/torvalds/linux

# You're now in ~/git/github.com/torvalds/linux/

# Later, from any directory, quickly navigate back
$ gt
# Interactive fuzzy-finder appears showing:
# github.com/torvalds/linux
# github.com/user/other-repo
# gitlab.com/org/project
# ...
```

## Directory Structure

All repositories are organized as:

```
~/git/
  ├── github.com/
  │   ├── user1/
  │   │   └── repo1/
  │   └── user2/
  │       └── repo2/
  └── gitlab.com/
      └── org/
          └── project/
```

This structure makes it easy to:
- Organize repos from multiple git servers
- Quickly identify the source of each repository
- Navigate between repositories efficiently
