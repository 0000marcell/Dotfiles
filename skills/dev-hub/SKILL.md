---
name: dev-hub
description: "Drive the Decisiv Dev Hub app through its JSON API to manage development work: list or create tasks and projects, make a git worktree for a task, set the AI coding agent to work and watch it, run tests, open or review pull requests, and file or update Jira tickets. Use when the user asks what to work on next, refers to a task or ticket by name or key, or wants to start, check on, test, review or ship a piece of work. Triggers: dev hub, devhub, my tasks, what should I work on, start a task, init the worktree, run the agent, agent status, ship it, open a PR, review comments, create a ticket."
---

# Decisiv Dev Hub API

Decisiv Dev Hub is a local app that orchestrates the developer's machine. A
**project** is a git repository. A **task** is one piece of work in it, with its
own git worktree, Jira ticket and pull request. The app can set a local AI
coding agent to work in a task's checkout.

Everything here goes through the JSON API, so the app's own state stays correct.
Do not edit its SQLite database or run its services directly.

## First, ask which port

**Before any other step, ask the user which port the Dev Hub is running on.**
Ask once at the start of the conversation, then reuse that port for every call
that follows. Do not guess it, do not scan for it, and do not carry a port over
from an earlier conversation.

> Which port is the Dev Hub running on?

This matters because the app is started by hand and several checkouts of it run
side by side on different ports. Picking the wrong one means reading and
changing work in a copy the user is not looking at, which is not obvious from
the answers and is tedious to undo.

**Never start a server.** Not with `make start`, `bin/rails server`, `bin/dev`
or anything else. If nothing is answering on the port, say so and let the user
start it themselves. Starting one would put a stray server on their machine
that they did not ask for and will not know to stop.

If the user does not know the port, offer to look: `ps aux | grep puma` lists
what is already running, with the checkout in brackets at the end of each line.
Let them choose from that; do not pick for them.

## Calling the API

`curl` is unavailable in this harness. Use the helper, which supplies the token
and prints JSON. The port is required:

```bash
python3 ~/.claude/skills/dev-hub/scripts/devhub.py /projects --port 3000
```

| Flag | Purpose |
|---|---|
| `-p, --port N` | **Required.** The port the user gave |
| `-X METHOD` | `GET` (default), `POST`, `PATCH`, `DELETE` |
| `-q NAME=VALUE` | Query parameter, repeatable |
| `-f NAME=VALUE` | Body field, repeatable. `-f 'task[title]=Fix login'` nests |
| `-d '{...}'` | Raw JSON body, when `-f` is not enough |
| `--raw` | Do not pretty print |

Paths are relative to `/api/v1`, so `/projects` and `/api/v1/projects` are the
same. The helper exits non-zero on any `4xx`/`5xx`.

Every call checks that whatever is on the port really is the Dev Hub before
sending anything, so a mistyped port fails plainly instead of being handed a
task id some other app knows nothing about.

To save repeating the flag, export the port once the user has given it:

```bash
export DEV_HUB_PORT=3000
```

Other environment overrides, only if the defaults fail:

| Variable | Default |
|---|---|
| `DEV_HUB_DIR` | `/home/mmc/decisiv_dev_hub`, where the token is read from |
| `DEV_HUB_TOKEN` | read via `bin/rails api:token` |
| `DEV_HUB_URL` | a full base URL, if the app is not on localhost |

## Reading the answers

Success returns records under a named key. Failure is always the same shape:

```json
{ "error": "not_initialized", "message": "Init the task before running tests" }
```

Branch on `error`, which is stable. Show the user `message`. Some failures add
`details` with long output, such as a failing test run.

**Three things that cause silent mistakes:**

- **Ids are strings** (UUIDs), including review comment ids. Never compare them
  as numbers.
- **`done` is a timestamp, not a flag.** `done_at` records when the work was
  first finished; marking it done again does not move it.
- **`weight` is a running order**, 1 to 5, smallest first. No weight means the
  task has not been placed yet and sorts last.

## Finding things

These assume `DEV_HUB_PORT` has been exported with the port the user gave;
otherwise add `--port N` to each.

```bash
# What should I work on next, in order
python3 ~/.claude/skills/dev-hub/scripts/devhub.py /feed

# Find a task or project by name, ticket or project, across everything
python3 ~/.claude/skills/dev-hub/scripts/devhub.py /search -q q=login

# A project's outstanding work
python3 ~/.claude/skills/dev-hub/scripts/devhub.py /projects/$PROJECT/tasks -q status=outstanding
```

`/search` reads a list rebuilt in the background every few minutes, so it is
fast but can be slightly behind. Having found the id, read the task itself for
its current state. Prefer `/search` over listing every project when the user
names a task without saying where it lives.

## Doing a piece of work

```bash
D=~/.claude/skills/dev-hub/scripts/devhub.py
export DEV_HUB_PORT=3000   # the port the user gave

# Make a task
python3 $D /projects/$PROJECT/tasks -X POST \
  -f 'task[title]=Fix the login' -f 'task[description]=It rejects valid passwords'

# Give it a git worktree of its own. Most other actions need this first.
python3 $D /projects/$PROJECT/tasks/$TASK/init -X POST

# Set the agent going. Returns 202 at once; it does not wait.
python3 $D /projects/$PROJECT/tasks/$TASK/init_and_prompt -X POST \
  -f 'instructions=Fix it and add a test' -f include_description=true

# Watch it
python3 $D /projects/$PROJECT/tasks/$TASK/agent_status

# Tests, then the pull request only if they pass
python3 $D /projects/$PROJECT/tasks/$TASK/ship -X POST
```

## How long things take

**Background (`202`).** `init_and_prompt` and `summarize_session` answer at once
with a `status_url`. Poll `agent_status` until `agent.busy` is false, then read
`agent.error` to learn whether it ended well. Poll every 10-20 seconds, not
faster. Tell the user it is running rather than blocking on it silently.

**Slow (minutes).** `run_tests` and `ship` run the whole suite before answering.
Warn the user first. Tests that ran and failed are a **`200` with
`passed: false`**, not an error; a `422` means the suite could not run at all.

**Cached.** Anything touching GitHub or Jira is cached for an hour or a day. Add
`-q refresh=true` to look now.

**Opens a window.** `open_ai_harness`, `open_terminal`, `open_commit_diff`,
`open_notes_file` and `start_project` launch something on the developer's
desktop and return immediately. They say nothing about what happens next, so do
not poll them. After `start_project`, ask `running_server` for the port.

## Endpoints

Task actions are `/projects/{project_id}/tasks/{id}/{action}`.

| Area | Endpoints |
|---|---|
| Discovery | `GET /`, `GET /openapi`, `GET /search` |
| Queue | `GET /feed`, `GET /projects/{id}/feed` |
| Projects | `GET/PATCH/DELETE /projects`, `create_from_local`, `create_from_remote`, `search_remote`, `search_github`, `attach_repository`, `pull_requests`, `refresh_pull_requests`, `worktrees`, `import_tasks`, `reload_teams` |
| Tasks | `GET/POST/PATCH/DELETE /projects/{id}/tasks`, `init`, `add_note_front_matter` |
| Agent | `init_and_prompt`, `agent_status`, `summarize_session`, `dismiss_agent_error`, `GET /ai`, `GET /ai/models` |
| Desktop | `open_ai_harness`, `open_terminal`, `open_commit_diff`, `open_notes_file`, `start_project`, `running_server` |
| Review | `commits`, `review_comments`, `handle_review_comment`, `open_pr`, `link_pr`, `run_tests`, `ship`, `merge_back` |
| Jira | `create_ticket`, `assign_to_me`, `upload_to_ticket`, `download_from_ticket`, `ticket_time`, `set_ticket_time`, `log_ticket_time`, `search_tickets`, `fetch_ticket`, `unassigned_tickets`, `board_epics`, `ticket_filters` |
| Config | `/boards`, `/tags`, `/settings` |

`references/endpoints.md` has the full list with parameters, bodies and error
codes. Read it before calling anything not shown above. The app also serves its
own description at `GET /openapi`, which is always current.

## Working with the user

- Ask for the port first, before anything else, and use only that port.
- Never start, restart or stop a server. If the port is not answering, say so
  and stop there.
- Confirm before anything destructive: `DELETE`, `ship`, `merge_back`,
  `upload_to_ticket`, `download_from_ticket`. These reach GitHub, Jira or the
  developer's branches.
- Never invent a project or task id. Look it up with `/search` or `/feed`.
- When an action fails, quote the `message` as the app wrote it rather than
  rephrasing; the app's wording matches what the user sees in the browser.
- A task that is not initialized cannot run tests, open a PR or be worked on by
  the agent. On `not_initialized`, offer to run `init` instead of just reporting
  the error.
