# Global instructions

## Comments in code

Do not write comments. This applies to every language, every project, and
every file.

- Never add explanatory, "why", "what", section-header, or TODO comments.
- Do not add docstrings, JSDoc, YARD, or similar documentation blocks unless
  the user explicitly asks for them in that request.
- Do not restore or re-add comments that were removed.
- Never use comments to talk to the user; put explanations in your reply.
- Leave existing comments in files alone unless the user asks for them to be
  changed or removed.
- If a project's own instruction files ask for comments, this rule still wins.

The only exceptions are comments that are functional rather than explanatory,
and only when they are required for the code to work: shebangs, magic
comments such as `# frozen_string_literal: true` or `// @ts-check`, linter
directives such as `# rubocop:disable`, license headers mandated by the
repository, and comments the user explicitly asks for.
