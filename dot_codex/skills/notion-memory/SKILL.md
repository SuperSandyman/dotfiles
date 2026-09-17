---
name: notion-memory
description: Search the connected Notion workspace when a request contains a standalone memory ID matching `MEM-[0-9]+`, case-insensitively. Use matching pages as read-only context unless the user explicitly requests a Notion change.
metadata:
  short-description: Look up MEM IDs in Notion
---

# Notion Memory Lookup

Look up memory pages in the connected Notion workspace when the request contains
one or more standalone memory IDs matching `MEM-[0-9]+`, case-insensitively.

## Trigger

Match tokens such as `MEM-123` or `mem-123`. A token may touch punctuation, but
must not be part of a larger sequence containing letters, digits, `_`, or `-`.
Extract every matching ID from the request and search for all of them.

## Workflow

1. Before answering or taking other actions, search Notion for each exact memory
   ID using the connected Notion tools. Do not use web search, local files, or
   model memory as a substitute.
2. Fetch matching page content and use it as context for the current request.
3. If an ID has no exact match, say so explicitly and do not invent its content.
   If multiple matches are ambiguous, report the candidates and ask for
   clarification only when the ambiguity blocks the requested work.
4. Keep the lookup read-only. Do not create or update Notion pages unless the
   user explicitly asks for that change.

If the Notion connector is unavailable, report that blocker instead of claiming
that the memory was found or silently substituting another data source.
