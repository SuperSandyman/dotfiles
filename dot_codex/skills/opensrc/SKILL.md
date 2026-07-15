---
name: opensrc
description: Use when users want to investigate a package in depth by tracing its source code. Run `npx opensrc <package-name>` and inspect the generated `opensrc/` directory to follow where the source files are.
---

# OpenSrc

Run package source investigation with `npx opensrc <package-name>`.

## Workflow
1. Run `npx opensrc <package-name>`.
2. Inspect the generated `opensrc/` directory.
3. Trace files under `opensrc/` to locate the package source and implementation details.

## Notes
- Replace `<package-name>` with the actual package name.
- Prefer reading original source files under `opensrc/` before relying on secondary summaries.
