---
name: worktree
description: Create and run feature work directly inside Git worktrees using git worktree. Use for requests that mention worktrees, parallel branch work, or implementing a plan file such as plan/feat-xxxxxx.md.
---

# Worktree

## Overview
Use `git worktree` to create a named worktree under `<repository-root>/worktrees/<branch-name>`, move to that worktree path, and do implementation work there.
Do not run nested `codex exec` from this skill.
Treat editing in the primary worktree (often main) as a mistake to avoid.

## Workflow
1. Move to the Git repository root.
2. Resolve the repository root and target path:
   `REPO_ROOT="$(git rev-parse --show-toplevel)"` and
   `WT_PATH="$REPO_ROOT/worktrees/<branch-name>"`.
3. Create the target's parent directory with `mkdir -p "$(dirname "$WT_PATH")"`.
4. Create the worktree with `git worktree add`. Use
   `git worktree add -b <branch-name> "$WT_PATH" [<start-point>]` for a new
   branch, or `git worktree add "$WT_PATH" <branch-name>` when the local
   branch already exists.
5. Change into `WT_PATH` and continue all actions in that directory.
6. Implement the plan at `$REPO_ROOT/plan/feat-xxxxxx.md`.
7. Keep all file edits and Git operations scoped to that worktree only.

## Commands
```bash
REPO_ROOT="$(git rev-parse --show-toplevel)"
BRANCH_NAME="feat/hogehoge"
WT_PATH="$REPO_ROOT/worktrees/$BRANCH_NAME"
mkdir -p "$(dirname "$WT_PATH")"

# create a new branch and worktree; omit -b when the branch already exists
git worktree add -b "$BRANCH_NAME" "$WT_PATH"

# move into worktree and work there
cd "$WT_PATH"

# safety check: top-level path must match selected worktree
test "$(pwd -P)" = "$(cd "$WT_PATH" && pwd -P)"
test "$(git rev-parse --show-toplevel)" = "$(cd "$WT_PATH" && pwd -P)"

# target plan
cat "$REPO_ROOT/plan/feat-xxxxxx.md"
```

## Safety Rules
- Never edit files while located in the primary worktree path.
- Before edits, confirm `pwd` and `git rev-parse --show-toplevel` both point to `WT_PATH`.
- If a command is about to run from the repository root or another worktree, stop and switch back to `WT_PATH`.
- Keep `WT_PATH` below the repository's `worktrees` directory; do not use a sibling or an arbitrary temporary path.

## Reusable Script
Use `scripts/executable_run-plan-impl.sh` to standardize the flow.
