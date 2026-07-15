#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Usage:
  $(basename "$0") --name feat-xxxxxx [--from REV]

Description:
  1) Create the worktree via wt (if missing)
  2) Resolve worktree path via wt path
  3) Enter a shell in that worktree
  4) Implement using prompt format:
     ../../plan/<name>.mdの内容を実装してください

Options:
  --name   Worktree/branch name (expected: feat-xxxxxx)
  --from   Revision for wt add --from (optional)
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

if ! command -v wt >/dev/null 2>&1; then
  echo "wt command not found on PATH." >&2
  exit 1
fi

if ! wt path "$NAME" >/dev/null 2>&1; then
  if [[ -n "$FROM_REV" ]]; then
    wt add "$NAME" --from "$FROM_REV"
  else
    wt add "$NAME"
  fi
fi

WT_PATH="$(wt path "$NAME")"
PRIMARY_WT_PATH="$(git worktree list --porcelain | awk '/^worktree /{print $2; exit}')"
PROMPT="../../plan/${NAME}.mdの内容を実装してください"

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
exec "${SHELL:-/bin/bash}" -l
