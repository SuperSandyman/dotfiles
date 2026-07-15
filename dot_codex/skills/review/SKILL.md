---
name: review
description: "Perform code review requests with a two-stage flow: review changes directly first, then optionally invoke GitHub Copilot for a second opinion when change volume is medium-to-large. Use when users ask to review code, mention review/reviewer, or use Japanese phrases like レビューしてほしい."
---

# Review

## Overview
Run review in two stages.
1. Review changes directly first.
2. If change volume is large enough, run GitHub Copilot review with `copilot -p "<prompt>" --allow-all-tools`.

## Workflow
1. Confirm review scope (`git status`, `git diff`, `git diff --cached`).
2. Produce direct review findings first, prioritized by severity.
3. Measure change volume and decide whether to run Copilot.
4. If criteria are met, run Copilot and merge useful findings.
5. Report final findings with clear source attribution:
- `direct`: findings from own review
- `copilot`: findings from Copilot output

## Copilot Invocation Rule
Use Copilot when at least one condition is true.
- Changed files: `>= 20`
- Total changed lines (`added + deleted`): `>= 1500`
- Large refactor indicators are present (rename/move-heavy diff, cross-module edits, migration/config-wide updates)

Skip Copilot when all are true.
- Changed files: `< 20`
- Total changed lines: `< 1500`
- Change is localized and behaviorally simple

Use this command format:
```bash
copilot -p "<review prompt>" --allow-all-tools
```

## Prompt Template
Use a concrete prompt that asks for bug/risk focused review.
```text
次の変更をコードレビューしてください。バグ、回帰リスク、セキュリティ問題、テスト不足を優先して指摘し、重大度順に列挙してください。
```

## Reusable Script
Use `scripts/copilot-review.sh` to decide and invoke Copilot consistently.
