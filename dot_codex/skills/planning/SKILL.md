---
name: planning
description: >
  When the user asks for a plan, requirements definition, feature summary, design,
  or a way to organize requirements, create a requirements-oriented document and
  save it as a page in the Notion database AI Base / AI Notes. Do not implement the
  requested feature as part of this workflow.
metadata:
  short-description: Requirements and feature definition saved to Notion AI Notes
---

# Requirements-First Skill

## Goal

Turn an idea, request, or feature discussion into a reviewable requirements
document. The document should clarify what to build and why, rather than prescribe
implementation steps. Save the result in the user's Notion workspace under
**AI Base / AI Notes**.

## When to apply

Apply this skill when the user asks to:

- 作る計画、設計、方針、要件定義、仕様、機能一覧、機能整理
- まず要件をまとめる、ユーザーストーリーを整理する、受け入れ条件を決める
- “plan first” or an equivalent requirements-first workflow

## Hard rules

1. **Requirements request ⇒ no implementation**
   - Do not edit application code, run mutating implementation commands, create a
     branch, or open a pull request as part of this workflow.
   - If the user also requests implementation, separate the requirements phase from
     implementation and wait for an explicit implementation request after the
     requirements are recorded.

2. **Notion is the source of truth for the document**
   - Use the connected Notion tools; do not save the document under a local
     `plan/` directory.
   - If Notion is unavailable or the target cannot be identified unambiguously,
     report the blocker and do not claim that the document was saved. Do not silently
     fall back to a local file.

3. **Separate facts from uncertainty**
   - Preserve confirmed requirements, assumptions, decisions, and open questions as
     separate sections.
   - Do not invent product behavior, constraints, users, or acceptance criteria.
   - Ask a question before saving only when the ambiguity prevents a meaningful
     requirements skeleton; otherwise record it under Open questions.

## Notion destination and workflow

Use the Notion connector in this order:

1. Search for the exact **AI Base** page and **AI Notes** database. Select the
   database whose ancestor path is `AI Base / AI Notes`; do not rely only on a
   similarly named page or database.
2. Fetch the AI Notes database before creating a page. Read its data-source URL and
   current property schema; use the exact title-property name and available option
   names returned by Notion.
3. Before creating or updating page content, fetch
   `notion://docs/enhanced-markdown-spec` through the Notion connector and follow
   that Notion-flavored Markdown specification. Put the page title in `properties`,
   not at the top of the page content.
4. Create one page under the AI Notes data source. Use a concise feature-oriented
   title, normally in the form `要件定義：<機能名>` or `<機能名>の要件整理`.
   Use the exact property names from the fetched schema. For the current AI Notes
   schema, set:
   - `Title`: the page title
   - `Source`: `Codex`
   - `Status`: `Inbox`
   - `Tags`: only existing options that are clearly applicable
   - `Project`: only when the related project is known; never guess a relation
   If the schema changes, adapt to its title property and available options rather
   than forcing these names or values.
5. Fetch the created page to verify its content and obtain the Notion URL. Report
   that URL along with a short summary. If this is a continuation of an existing
   requirements document, fetch and update the matching page instead of creating a
   duplicate, preserving child content.

## Codex CLI prerequisite

When running in Codex CLI, use the official `notion@openai-curated` plugin. It must
be installed and enabled, and the Notion connector must be authenticated in the
current Codex account. The one-time setup is:

```sh
codex plugin add notion@openai-curated
codex login status
```

Start a new CLI session after installing the plugin. Complete any browser-based
Notion connection prompt when it appears. Never put Notion OAuth tokens, API keys,
or `~/.codex/auth.json` into dotfiles. If the connector is unavailable in the
current CLI session, report the setup blocker instead of writing a local fallback.

## Requirements document structure

Write in Japanese unless the user uses English. Adapt the sections to the request,
but cover the following where relevant:

1. **概要** — 背景、現状の課題、目的、対象範囲
2. **ゴール / 非ゴール** — 今回達成すること、明確に対象外とすること
3. **利用者とユースケース** — 対象ユーザー、利用シーン、ユーザーストーリー
4. **機能概要** — 機能のまとまり、主要な画面・操作・入出力・連携
5. **機能要件** — `FR-001` のような ID、前提、期待する振る舞い、例外・境界条件
6. **非機能要件** — 性能、可用性、セキュリティ、権限、互換性、運用、アクセシビリティ
7. **受け入れ条件** — 要件を満たしたと判断できる observable な条件
8. **制約・前提・決定事項** — 技術や運用上の既知の制約と、確定した判断
9. **未決事項 / オープンクエスチョン** — 実装前に確認が必要な項目

Do not turn the document into a file-by-file implementation plan, branch/worktree
proposal, task breakdown, or test-command checklist. Testability may be expressed
as acceptance conditions, but implementation sequencing belongs to a later phase.

## Interaction style

- Requirements整理中は、目的・前提・選択肢・判断理由を短く明示する。
- 仕様として確定していない内容は「仮定」または「未決事項」として書く。
- 完成後は Notion ページ URL、保存先（AI Base / AI Notes）、主な未決事項だけを返す。
