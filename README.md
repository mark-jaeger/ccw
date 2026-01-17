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
ccw                      # Open worktree (interactive selector)
ccw create <name>        # Create worktree from staging + start Claude Code
ccw open [name]          # Open existing worktree
ccw list                 # List worktrees for current repo
ccw merge staging        # Squash-merge current feature into staging
ccw merge main           # Merge staging into main (enforced)
ccw sync                 # Pull latest staging into current branch
ccw remove <name>        # Remove worktree (prompts if not merged)
ccw cleanup              # Remove all merged worktrees
ccw config               # View/set configuration
```

## Workflow

ccw enforces an opinionated git workflow designed for testing before production:

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   feature   │────▶│   staging   │────▶│    main     │
│  (worktree) │     │   (test)    │     │ (production)│
└─────────────┘     └─────────────┘     └─────────────┘
```

**The flow:**

1. **Create** — Worktrees always branch from `staging` (not `main` or `HEAD`)
2. **Develop** — Work in your isolated worktree with Claude Code
3. **Merge to staging** — Squash-merge keeps history clean, one commit per feature
4. **Test** — Deploy staging to your test server, iterate until it works
5. **Merge to main** — Only allowed from staging branch, ships tested code to production
6. **Cleanup** — Remove merged worktrees when done

**Why this approach:**

- **Branch from staging**: Your feature includes all in-progress work, reducing merge conflicts
- **Squash to staging**: One commit per feature makes reverts trivial (`git revert <sha>`)
- **Enforce staging→main**: Prevents accidentally shipping untested code
- **Regular merge to main**: Preserves deployment history ("this batch shipped together")

## Example

```bash
# Start working on a feature
cd ~/projects/my-app
ccw create user-auth

# Claude Code opens in ~/worktrees/my-app/user-auth
# Branch: feature/user-auth (based on staging)

# ... develop your feature ...

# Ready to test? Merge to staging
ccw merge staging
# Review staged changes, then:
git commit -m "feat: add user authentication"
git push origin staging

# Deploy staging to your test server and verify...

# Found a bug? Go back to worktree and fix
ccw open user-auth
ccw sync                  # Get latest staging changes if needed
# ... fix the bug ...
ccw merge staging
git commit -m "fix: handle expired tokens"
git push origin staging

# Staging tests pass! Ship to production
ccw merge main
git push origin main

# Clean up
ccw cleanup               # Removes feature/user-auth worktree
```

## Running Parallel Features

```bash
# Terminal 1: Work on auth
ccw create user-auth

# Terminal 2: Work on dark mode (same repo!)
ccw create dark-mode

# Each worktree is isolated - no branch conflicts
# Both branch from staging, merge independently

# List all active worktrees
ccw list
```

## How it works

- Worktrees created in `~/worktrees/<repo-name>/<feature-name>`
- Branches named `feature/<feature-name>`
- Always branches from `staging` (fetches latest first)
- Copies `.env` file if present
- Runs `npm install` if `package.json` exists

## Merge Strategies

| Command | Strategy | Why |
|---------|----------|-----|
| `ccw merge staging` | Squash | One clean commit per feature. Easy to revert. |
| `ccw merge main` | Regular merge | Preserves staging history. Clear deployment boundaries. |

## Configuration

Config file: `~/.config/ccw/config`

```bash
# View current config
ccw config
```

(No config options currently available)

## Prerequisites

Your repo needs a `staging` branch:

```bash
# If you don't have one yet
git checkout -b staging
git push -u origin staging
```

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
- A `staging` branch in your repo

## License

MIT
