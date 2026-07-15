---
name: planning
description: >
  When the user asks for a plan/計画/設計/方針/手順を作る, create a written plan only (no implementation).
  Save the plan as a Markdown file under <project-root>/plan/ using the intended branch name or worktree name.
metadata:
  short-description: Plan-only workflow + save plan under ./plan/ using a branch-based filename
---

# Codex Plan-First Skill

## Goal
Provide a reliable “plan-first” workflow:
- If asked to create a plan, **do not implement**.
- Persist the plan as a Markdown file under **<project-root>/plan/**.
- Handle unclear requirements explicitly, either by saving a plan with clearly separated assumptions/open questions or by asking before saving when a meaningful plan cannot be written.

## When to apply
Apply this skill when the user message includes intents such as:
- “プラン作って / 計画立てて / 設計して / 方針出して / 手順まとめて”
- “Plan mode で” “まず計画”
- “作業手順だけ欲しい（実装は後）”

## Hard rules (must follow)
1. **Plan request ⇒ No implementation**
   - Do NOT edit code, do NOT run commands that change files, do NOT create PRs.
   - Only analyze, propose, and write the plan document.

2. **Always save the plan**
   - Save the plan file at:  
     `<project-root>/plan/<NAME>.md`

   - `<NAME>` must be derived from the **intended branch name**.
   - Never use placeholder names such as `plan-unnamed`, `unnamed`, `tmp`, or date-only names.
   - You must decide the filename before writing the plan.
   - If the branch name is not given, propose one first using the branch naming rules below, then save the plan with that branch-based filename.
   - If you still cannot derive or propose a reasonable branch name, stop and ask the user instead of creating a temporary filename.
   - Worktree name may be proposed separately, but it does not replace the branch-based filename rule.
   - A plan is not complete unless the saved file path is concrete and branch-based.

   - **Important:** Do NOT create nested directories based on `<type>/...`.  
     Instead, **flatten** branch/worktree names into a single filename:
     - Replace `/` with `-`
     - Example: `feat/add-image-upload` → `plan/feat-add-image-upload.md`
     - Example: `chore/cleanup-worktree-db` → `plan/chore-cleanup-worktree-db.md`

3. **Ask questions when unclear**
   - Planning may include unknowns. Do not treat every unknown as a blocker.
   - If a useful plan can still be written, save the plan and put the unknowns in **Open questions**. Separate confirmed assumptions from unresolved items.
   - Stop and ask the user **before saving** only when the uncertainty prevents a meaningful branch name or plan skeleton. Typical blockers:
     - the requested change/domain is too vague to infer a purpose or change type
     - a safe branch name cannot be reasonably proposed
     - the user asks for a plan but gives conflicting goals that would produce different plans
   - If any of the following is missing/ambiguous but not blocking, record it in **Open questions** as implementation-before-start confirmation:
     - target behavior / acceptance criteria
     - affected modules or files
     - constraints (compatibility, performance, security, style)
     - branch naming (if it cannot be reasonably proposed from the request; do not fall back to `plan-unnamed.md`)
     - test strategy / expected environment

## Branch naming (must follow)
Use short, readable branch names with a consistent prefix and 2–5 English words.

### Format
- `<type>/<word1>-<word2>-<word3>` or `<type>/<word1>-<word2>-<word3>-<word4>`
- Lowercase only
- Words are hyphen-separated
- Avoid abbreviations unless they are widely understood (e.g., `api`, `ui`, `ci`)

### Types
- `feat/` — new features
- `fix/` — bug fixes (non-urgent)
- `hotfix/` — urgent production fixes
- `chore/` — maintenance, refactors, tooling, CI, docs (non-feature work)

### Examples
- `feat/add-image-upload`
- `feat/enable-markdown-preview`
- `fix/prevent-null-config`
- `hotfix/restore-ci-release`
- `chore/cleanup-worktree-db`

## Plan document structure (write in Japanese unless the user uses English)
In the saved plan markdown, include at minimum:

1. **Summary**
   - 目的（何を達成するか）
   - 非目的（今回はやらないこと）

2. **Proposed branch/worktree**
   - Branch name:
   - Worktree name:
   - Plan file path: `plan/...`

3. **Scope & impact**
   - 変更対象（主要ファイル/モジュール候補）
   - 影響範囲（API/UI/DB/設定/CIなど）

4. **Steps**
   - 手順を番号付きで（小さく分割）
   - 各手順の完了条件（Done criteria）

5. **Risks & mitigations**
   - 想定リスク
   - 回避策/ロールバック案

6. **Validation**
   - テスト方針（unit/integration/e2e）
   - 具体的な確認観点（最低3つ）

7. **Open questions**
   - 実装に必要な確認事項（質問リスト）

## Ambiguity handling examples
- User gives a clear change but omits branch name: propose a branch name, save the plan, and list remaining implementation questions.
  - Example: “一覧に検索を追加する計画だけ” → `feat/add-list-search` → `plan/feat-add-list-search.md`
- User gives a branch name: use it exactly for the branch, flatten it for the filename, and save the plan.
  - Example: `fix/dashboard-blank-screen` → `plan/fix-dashboard-blank-screen.md`
- User gives only a worktree name: do not use it as the filename by itself. Propose a branch name from the requested work and use the flattened branch name for the plan file. If the requested work is too vague to infer a branch, ask first.
  - Example: worktree `cleanup-db`, request “DBまわりを整理” → propose `chore/cleanup-database-layer` if that is a reasonable interpretation, then save `plan/chore-cleanup-database-layer.md` with assumptions and open questions.
- User gives too little to infer a meaningful plan, such as “なんか改善する計画を作って”: ask for the target area and desired outcome before saving.

## Interaction style
- Plan作成中は、断定よりも「前提」「選択肢」「理由」を明確にする。
- 不明点はまとめて質問し、ユーザーの回答を待ってから次のフェーズへ進む。
- 余計な長文化を避け、実装に直結する粒度で書く（箇条書き中心）。
- `plan-unnamed.md` を含む仮名ファイルは作らない。先に branch name と plan file path を確定させる。
