---
name: worktree
description: Create and run feature work directly inside Git worktrees using the wt CLI. Use for requests that mention worktree/wt, parallel branch work, or implementing a plan file such as ../../plan/feat-xxxxxx.md.
---

# Worktree

## Overview
Use `wt` to create a named worktree, move to that worktree path, and do implementation work there.
Do not run nested `codex exec` from this skill.
Treat editing in the primary worktree (often main) as a mistake to avoid.

## Workflow
1. Move to the Git repository root.
2. Initialize `wt` once per repository if needed.
3. Create the worktree with `wt add <branch-name>`.
4. Resolve the path with `wt path <branch-name>`.
5. Change into the worktree directory and continue all actions in that directory.
6. Implement the plan from `../../plan/feat-xxxxxx.md`.
7. Keep all file edits and Git operations scoped to that worktree only.

`wt add` accepts the branch name as-is, including slashes. For example, use `wt add feat/hogehoge`, not `wt add feat-hogehoge`.

## Commands
```bash
# one-time per repository
wt init

# create worktree with the branch name as-is
wt add feat/hogehoge

# get path
WT_PATH="$(wt path feat/hogehoge)"

# move into worktree and work there
cd "$WT_PATH"

# safety check: top-level path must match selected worktree
test "$(git rev-parse --show-toplevel)" = "$WT_PATH"

# target plan
cat ../../plan/feat-xxxxxx.md
```

## Safety Rules
- Never edit files while located in the primary worktree path.
- Before edits, confirm `pwd` and `git rev-parse --show-toplevel` both point to `WT_PATH`.
- If a command is about to run from repo root or another worktree, stop and switch back to `WT_PATH`.

## Reusable Script
Use `scripts/run-plan-impl.sh` to standardize the flow.
