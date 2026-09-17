#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Usage:
  $(basename "$0") --name feat-xxxxxx [--from REV]

Description:
  1) Find the repository root
  2) Create the worktree under <repository-root>/worktrees/<name> via git worktree (if missing)
  3) Enter a shell in that worktree
  4) Implement using prompt format:
     <repository-root>/plan/<name>.mdの内容を実装してください

Options:
  --name   Worktree/branch name (expected: feat-xxxxxx)
  --from   Starting revision for a newly created branch (optional)
USAGE
}

NAME=""
FROM_REV=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)
      NAME="${2:-}"
      shift 2
      ;;
    --from)
      FROM_REV="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$NAME" ]]; then
  echo "--name is required" >&2
  usage
  exit 1
fi

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "Run this command inside a Git repository." >&2
  exit 1
fi

if ! git check-ref-format --branch "$NAME" >/dev/null 2>&1; then
  echo "Invalid branch name: $NAME" >&2
  exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"
REPO_ROOT="$(cd "$REPO_ROOT" && pwd -P)"
WORKTREE_ROOT="$REPO_ROOT/worktrees"
WT_PATH="$WORKTREE_ROOT/$NAME"

if [[ -e "$WT_PATH" ]]; then
  if [[ ! -d "$WT_PATH" || ! -e "$WT_PATH/.git" ]]; then
    echo "Refusing to use existing non-worktree path: $WT_PATH" >&2
    exit 1
  fi

  ACTUAL_WT_PATH="$(git -C "$WT_PATH" rev-parse --show-toplevel 2>/dev/null || true)"
  ACTUAL_WT_PATH="$(cd "$ACTUAL_WT_PATH" 2>/dev/null && pwd -P || true)"
  EXPECTED_WT_PATH="$(cd "$WT_PATH" && pwd -P)"
  if [[ -z "$ACTUAL_WT_PATH" || "$ACTUAL_WT_PATH" != "$EXPECTED_WT_PATH" ]]; then
    echo "Existing path is not a valid Git worktree: $WT_PATH" >&2
    exit 1
  fi

  CURRENT_BRANCH="$(git -C "$WT_PATH" symbolic-ref --quiet --short HEAD || true)"
  if [[ "$CURRENT_BRANCH" != "$NAME" ]]; then
    echo "Existing worktree has branch '${CURRENT_BRANCH:-detached}', expected '$NAME'." >&2
    exit 1
  fi
else
  mkdir -p "$(dirname "$WT_PATH")"

  if git show-ref --verify --quiet "refs/heads/$NAME"; then
    if [[ -n "$FROM_REV" ]]; then
      echo "--from can only be used when creating a new branch: $NAME" >&2
      exit 1
    fi
    git worktree add "$WT_PATH" "$NAME"
  elif [[ -n "$FROM_REV" ]]; then
    git worktree add -b "$NAME" "$WT_PATH" "$FROM_REV"
  else
    git worktree add -b "$NAME" "$WT_PATH"
  fi
fi

WT_PATH="$(cd "$WT_PATH" && pwd -P)"
PRIMARY_WT_PATH="$(git worktree list --porcelain | awk 'substr($0, 1, 9) == "worktree " { print substr($0, 10); exit }')"
if [[ -n "$PRIMARY_WT_PATH" ]]; then
  PRIMARY_WT_PATH="$(cd "$PRIMARY_WT_PATH" && pwd -P)"
fi
PROMPT="$REPO_ROOT/plan/${NAME}.mdの内容を実装してください"

if [[ -n "${PRIMARY_WT_PATH}" && "$WT_PATH" == "$PRIMARY_WT_PATH" ]]; then
  echo "Refusing to continue: target is the primary worktree ($PRIMARY_WT_PATH)." >&2
  echo "Choose a dedicated feature worktree name, e.g. feat-xxxxxx." >&2
  exit 1
fi

echo "Worktree ready: $WT_PATH"
echo "Prompt: $PROMPT"
echo "Primary worktree: ${PRIMARY_WT_PATH:-unknown}"
echo "Safety: do not edit files outside $WT_PATH"
echo "Entering shell in worktree. Exit shell to return."

cd "$WT_PATH"
test "$(pwd -P)" = "$WT_PATH"
test "$(git rev-parse --show-toplevel)" = "$WT_PATH"
exec "${SHELL:-/bin/bash}" -l
