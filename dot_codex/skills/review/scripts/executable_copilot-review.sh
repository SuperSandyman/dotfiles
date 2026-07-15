#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  copilot-review.sh [--prompt "text"] [--force] [--no-run]

Description:
  Decide whether to invoke GitHub Copilot review from current git diff volume.
  Thresholds:
    - changed files >= 20 OR
    - added+deleted lines >= 1500
  If threshold matches, run:
    copilot -p "<prompt>" --allow-all-tools

Options:
  --prompt  Override default review prompt
  --force   Invoke Copilot regardless of thresholds
  --no-run  Print decision and command only
USAGE
}

PROMPT="次の変更をコードレビューしてください。バグ、回帰リスク、セキュリティ問題、テスト不足を優先して指摘し、重大度順に列挙してください。"
FORCE=0
NO_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --prompt)
      PROMPT="${2:-}"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --no-run)
      NO_RUN=1
      shift
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

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Run this inside a git repository." >&2
  exit 1
fi

if ! command -v awk >/dev/null 2>&1; then
  echo "awk is required." >&2
  exit 1
fi

# Count files across staged + unstaged changes, excluding untracked files.
CHANGED_FILES="$(git diff --name-only HEAD | sed '/^$/d' | sort -u | wc -l | tr -d ' ')"
if [[ -z "$CHANGED_FILES" ]]; then
  CHANGED_FILES=0
fi

SHORTSTAT="$(git diff --shortstat HEAD || true)"
ADDED="$(printf '%s\n' "$SHORTSTAT" | awk -F',' '
  {
    for (i = 1; i <= NF; i++) {
      if ($i ~ /insertion/) {
        gsub(/[^0-9]/, "", $i);
        if ($i != "") print $i;
      }
    }
  }' | head -n1)"
DELETED="$(printf '%s\n' "$SHORTSTAT" | awk -F',' '
  {
    for (i = 1; i <= NF; i++) {
      if ($i ~ /deletion/) {
        gsub(/[^0-9]/, "", $i);
        if ($i != "") print $i;
      }
    }
  }' | head -n1)"

ADDED="${ADDED:-0}"
DELETED="${DELETED:-0}"
TOTAL_LINES=$((ADDED + DELETED))

RUN=0
REASON="below threshold"
if [[ "$FORCE" -eq 1 ]]; then
  RUN=1
  REASON="forced"
elif [[ "$CHANGED_FILES" -ge 20 || "$TOTAL_LINES" -ge 1500 ]]; then
  RUN=1
  REASON="threshold met"
fi

echo "changed_files=$CHANGED_FILES added=$ADDED deleted=$DELETED total_lines=$TOTAL_LINES decision=$RUN reason=$REASON"
echo "command: copilot -p \"$PROMPT\" --allow-all-tools"

if [[ "$RUN" -eq 1 && "$NO_RUN" -eq 0 ]]; then
  if ! command -v copilot >/dev/null 2>&1; then
    echo "copilot command not found on PATH." >&2
    exit 1
  fi
  copilot -p "$PROMPT" --allow-all-tools
fi
