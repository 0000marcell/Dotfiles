---
name: pr-flow-graph
description: "Generate a Mermaid flow chart that guides PR reviewers through a change, starting at the PR entry point and fanning out to the files touched and how the feature behaves. Use when the user asks for a review graph, reviewer flow chart, PR walkthrough diagram, or a mermaid chart of their work. Triggers: flow chart, flowchart, mermaid, review graph, reviewer guide, PR walkthrough, diagram my changes."
---

# PR Flow Graph

Produce a Mermaid `flowchart TD` that lets a reviewer read the change linearly: start at the PR entry point, follow the runtime paths the feature creates, and see the file paths that implement each step.

## Output location

Always write to `/home/mmc/mermaid.mmd`, overwriting any existing content. Do not create other filenames unless the user asks.

## Procedure

1. Establish the change set. Run `git -C <worktree> status --short`, `git log --oneline <base>..HEAD`, and `git diff --stat <base>...HEAD`. Use the current worktree, not the directory the shell started in. If the base branch is unclear, use `main`.
2. Read the touched files that define behavior. Skip lockfiles, generated assets, and pure formatting. Use `lsp_symbols` or targeted views instead of reading large files whole.
3. Identify entry points: routes, layouts, controller actions, jobs, rake tasks, CLI commands, or UI triggers that a user or system hits first.
4. Trace the flow from each entry point through the code paths, including branches (`{decision}` nodes) for conditions the code actually checks.
5. Attach real file paths to nodes. Include the relevant DOM hooks, route names, or data attributes when they are how the pieces connect.
6. Add a test node for specs that cover the behavior, linked with dotted edges.
7. Write the file, then open it with the viewer (see below).

## Diagram rules

- Use `flowchart TD`.
- The first node is the PR itself: title and branch name. Every path begins from it.
- Group paths by runtime concern (browser, server, background, data). Keep one path per trigger.
- Use `-->` for control flow, `-. "label" .->` for verification or user actions, and `{...}` for decisions with `Yes` and `No` edges.
- Node labels: a short behavior sentence, then the file path on its own line using `<br/>`.
- Quote every label that contains special characters. Avoid parentheses or brackets inside unquoted labels.
- Stay accurate. Do not invent nodes for code that does not exist in the diff.
- Keep it reviewable: aim for roughly 15 to 40 nodes. Collapse trivial helpers.
- No comments inside the file except the Mermaid `%%` lines the user explicitly wants. Do not add a legend.

## Opening the graph

After saving `/home/mmc/mermaid.mmd`, open it with:

```bash
/home/mmc/mermaid-view /home/mmc/mermaid.mmd
```

The script renders `mermaid.svg` next to the input with `mmdc` and opens it in Brave. It prints the output path. If it fails, report the error and give the user the path to the `.mmd` file so they can paste it into mermaid.live.

Do not run this viewer if the user asks only for the file contents.

## Checks before finishing

- Every file path in the chart exists in the repo or is a new file in the diff.
- The graph has exactly one PR entry node.
- Every decision node has labeled `Yes` and `No` edges (or a clearly named equivalent).
- Syntax is valid Mermaid. Mention in the final reply that the render was not verified in a browser if the viewer could not run.

## Reply format

Keep the reply to a few lines: the saved path, and that the viewer was opened (or why it was not).
