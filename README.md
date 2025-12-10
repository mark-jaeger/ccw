# ccw - Claude Code Worktree Manager

Simple CLI for managing git worktrees with [Claude Code](https://claude.ai/claude-code).

Run parallel Claude Code sessions on the same repo without branch conflicts.

## Install

```bash
# Clone
git clone https://github.com/mark-jaeger/ccw.git ~/.ccw

# Add to PATH (add to .zshrc or .bashrc)
export PATH="$HOME/.ccw:$PATH"
```

Or one-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/mark-jaeger/ccw/main/install.sh | bash
```

## Usage

```bash
ccw create <name>   # Create worktree + start Claude Code
ccw list            # List worktrees for current repo
ccw remove <name>   # Remove worktree (prompts if not merged)
ccw cleanup         # Remove all merged worktrees
```

## Example

```bash
# Start working on a feature
cd ~/projects/my-app
ccw create user-auth

# Claude Code opens in ~/worktrees/my-app/user-auth
# Branch: feature/user-auth

# In another terminal, start a different feature
ccw create dark-mode

# List all worktrees
ccw list

# When done (after merging PR)
ccw remove user-auth

# Or clean up all merged worktrees at once
ccw cleanup
```

## How it works

- Worktrees created in `~/worktrees/<repo-name>/<feature-name>`
- Branches named `feature/<feature-name>`
- Copies `.env` file if present
- Runs `npm install` if `package.json` exists
- Starts Claude Code with `--dangerously-skip-permissions`

## Why worktrees?

Git worktrees let you have multiple working directories for the same repo. Each worktree has its own branch and file state, perfect for:

- Running parallel Claude Code sessions
- A/B testing different implementations
- Working on a hotfix while a feature is in progress
- Keeping context separate between tasks

## Requirements

- Git 2.5+
- [Claude Code](https://claude.ai/claude-code) installed globally
- Bash

## License

MIT
