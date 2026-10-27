# Dev Hub API: every endpoint

Generated from the app's own OpenAPI description. Paths below include the
`/api/v1` prefix; the helper script accepts them with or without it.

The port is required. Ask the user which port the Dev Hub is on, then pass
`--port N` or export `DEV_HUB_PORT`. Never start a server.

Call anything here with:

```bash
python3 ~/.claude/skills/dev-hub/scripts/devhub.py PATH --port N [-X METHOD] [-q k=v] [-f k=v]
```

## Discovery

### `GET /api/v1`

What this API is and how to authenticate

Answered without a token, so a caller can find out how to get in.

Answers: `200` The name, version and authentication scheme.

### `GET /api/v1/openapi`

This description, as JSON

Answered without a token, so a client can read it before authenticating.

Answers: `200` The OpenAPI description of every endpoint.

### `GET /api/v1/search`

Find a project or task by name, across everything

For getting to a task without knowing which project it belongs to. Matches a task's title, ticket or project name, and a project's name.

This reads the same prepared list the app's keyboard palette searches, rebuilt in the background every few minutes, so it answers immediately but can be slightly behind. Read the task itself for its current state. Only outstanding tasks are listed; finished work is not.

An empty search lists the first few of each, so a client can see what is there.

Query parameters:

- `q` (string)
- `limit` (integer)

Answers: `200` What matched, with the path of each.

## Projects

### `GET /api/v1/projects`

Every project

Answers: `200` The projects, newest first.

### `POST /api/v1/projects/create_from_local`

Make a project from a checkout already on this machine

The name and remote are read out of the repository itself.

Body:

- `local_path` (string) **required** - Path to a git checkout on this machine.

Answers: `201` The project that was made.; `422` Failure

### `POST /api/v1/projects/create_from_remote`

Clone a GitHub repository and make a project of it

Body:

- `name_with_owner` (string) **required**

Answers: `201` The project that was made.; `422` Failure

### `GET /api/v1/projects/search_remote`

Search GitHub for a repository to make a project from

Query parameters:

- `q` (string)

Answers: `200` Matching repositories.; `422` Failure

### `GET /api/v1/projects/{id}`

One project, with its scripts and how much work is left

Answers: `200` The project.; `404` NotFound

### `PATCH /api/v1/projects/{id}`

Change a project

Body:

- `project` (object, see ProjectInput below)

Answers: `200` The project as it now stands.; `422` Invalid

### `DELETE /api/v1/projects/{id}`

Delete a project and its tasks

The checkout on disk is left alone; only the record goes.

Answers: `200` Ok

### `POST /api/v1/projects/{id}/attach_repository`

Point an existing project at a GitHub repository

Naming a destination clones the repository there and points the project at the clone. Leaving it out records the remote without cloning.

Body:

- `name_with_owner` (string) **required**
- `destination` (string)

Answers: `200` The project as it now stands.; `422` Failure

### `POST /api/v1/projects/{id}/import_tasks`

Make many tasks at once from a written list

Each task is a block beginning with a markdown heading, which becomes the title, followed by its description. Blocks are divided by a line of three or more equals signs. The whole list is checked before anything is saved, so one mistake imports nothing.

Body:

- `content` (string) **required**

Answers: `201` The tasks that were made.; `422` Failure

### `GET /api/v1/projects/{id}/pull_requests`

The open pull requests on this project

Cached for a day, because reaching GitHub is slow. Pass `refresh=true` to go and look now.

Query parameters:

- `refresh` (boolean)

Answers: `200` The pull requests, and when the list was last fetched.; `422` Failure

### `POST /api/v1/projects/{id}/refresh_pull_requests`

Fetch the open pull requests from GitHub now

Answers: `200` The pull requests as GitHub has them.; `422` Failure

### `GET /api/v1/projects/{id}/search_github`

Search GitHub for a repository to attach to this project

Query parameters:

- `q` (string)

Answers: `200` Matching repositories.; `422` Failure

### `GET /api/v1/projects/{id}/worktrees`

The git checkouts this project already has

For pointing a task at work started outside the app.

Answers: `200` The paths of the checkouts.

## Tasks

### `GET /api/v1/feed`

What to work on next, across every project

The running order of outstanding work, smallest weight first, with unweighted tasks at the back. With no project named it follows whatever was last being worked on.

Answers: `200` The queue, in the order it should be worked through.

### `GET /api/v1/projects/{project_id}/feed`

What to work on next in one project

Answers: `200` The queue for this project.

### `GET /api/v1/projects/{project_id}/tasks`

A project's tasks

Query parameters:

- `status` (string, one of `outstanding`, `done`) - `outstanding` for what is left to do, in the order it should be worked through; `done` for finished work, most recently finished first. Left out, every task comes back newest first.

Answers: `200` The tasks.

### `POST /api/v1/projects/{project_id}/tasks`

Make a task

Body:

- `task` (object, see TaskInput below)

Answers: `201` The task that was made.; `422` Invalid

### `GET /api/v1/projects/{project_id}/tasks/{id}`

One task, in full

Answers: `200` The task.; `404` NotFound

### `PATCH /api/v1/projects/{project_id}/tasks/{id}`

Change a task

Body:

- `task` (object, see TaskInput below)

Answers: `200` The task as it now stands.; `422` Invalid

### `DELETE /api/v1/projects/{project_id}/tasks/{id}`

Delete a task

Answers: `200` Ok

### `POST /api/v1/projects/{project_id}/tasks/{id}/add_note_front_matter`

Put the task's links at the top of its notes

Writes the ticket, the pull request and where the code sits as YAML front matter, so a notes file carries the links worth having to hand. Only what the task actually knows is written.

Answers: `200` The task, with its notes rewritten.; `422` `nothing_to_add` when the task has no links yet.

### `POST /api/v1/projects/{project_id}/tasks/{id}/init`

Give the task a git checkout of its own

Makes a worktree beside the project's checkout, on a branch named after the task's ticket and title. A directory that is already there is adopted rather than treated as a mistake. Most things a task can do need this first.

Answers: `200` Where the checkout was made.; `422` Failure

## Agent

### `GET /api/v1/ai`

Whether the local AI agent is up

Tells a refused prompt apart from an agent that was never running.

Answers: `200` Whether the agent answered, and the socket it was asked on.

### `GET /api/v1/ai/models`

The models the agent can run

Answers: `200` The model names, as the agent reports them.; `422` Failure

### `GET /api/v1/projects/{project_id}/tasks/{id}/agent_status`

What the agent is doing right now

The endpoint to poll after starting a run. `busy` goes false when the run ends; `error` says why if it stopped badly.

Answers: `200` The agent's state, and the recap if one has been written.

### `POST /api/v1/projects/{project_id}/tasks/{id}/dismiss_agent_error`

Forget why the last agent run stopped

Answers: `200` The agent's state, with the error cleared.

### `POST /api/v1/projects/{project_id}/tasks/{id}/init_and_prompt`

Ask the AI agent to do the work

Makes the checkout if it is missing and sets the agent going in it. The agent can work for minutes, far longer than a request can wait, so the run is handed to a background job and `202` comes back at once with a `status_url` to poll.

Body:

- `instructions` (string) - What to tell the agent, on top of the task itself.
- `include_description` (boolean) - Put the task's description in the prompt.
- `include_notes` (boolean) - Put the task's notes in the prompt.

Answers: `202` The run was accepted. Poll `status_url` to watch it.; `422` `agent_busy` when the agent is already working on this task.

### `POST /api/v1/projects/{project_id}/tasks/{id}/summarize_session`

Write a recap of the agent's conversation

Runs in the background like a prompt does. Needs a conversation to summarize, so a task the agent has never worked on is turned away with `no_session`.

Answers: `202` The summary was accepted. Poll `status_url` to watch it.; `422` Failure

## Desktop

### `POST /api/v1/projects/{project_id}/tasks/{id}/open_ai_harness`

Open the AI harness in the task's checkout

Opens a terminal on the developer's machine and starts the harness in it, resuming the task's conversation. Returns as soon as the window was opened; nothing is reported about what happens in it.

Answers: `200` Opened; `422` Failure

### `POST /api/v1/projects/{project_id}/tasks/{id}/open_commit_diff`

Show a commit's diff in a terminal

Body:

- `revision` (string) **required** - A commit sha, as listed by the commits endpoint.

Answers: `200` Opened; `422` Failure

### `POST /api/v1/projects/{project_id}/tasks/{id}/open_notes_file`

Open the file the task's notes are linked to

Answers: `200` Opened; `422` Failure

### `POST /api/v1/projects/{project_id}/tasks/{id}/open_terminal`

Open a terminal in the task's checkout

Answers: `200` Opened; `422` Failure

### `GET /api/v1/projects/{project_id}/tasks/{id}/running_server`

Whether the app is up on this task's checkout, and on which port

Several tasks of one project usually run side by side on different ports, so this reads the checkout's own pidfile rather than guessing from the machine at large. Nothing running is an ordinary answer; being unable to tell is reported in `unavailable_because`.

Answers: `200` What could be found out about the checkout.

### `POST /api/v1/projects/{project_id}/tasks/{id}/start_project`

Run the project's start script in the task's checkout

Starts the app from this task's code, usually a web server. The port it came up on is found with the running server endpoint rather than here, because the server takes a moment to record itself.

Answers: `200` The project was started.; `422` Failure

## Review

### `GET /api/v1/projects/{project_id}/tasks/{id}/commits`

The commits made on this task's own branch

Only what is in the task's checkout and not yet in the branch it was started from, so what comes back is the task's own work.

Answers: `200` The commits, newest first.; `422` Failure

### `PATCH /api/v1/projects/{project_id}/tasks/{id}/handle_review_comment`

Mark a review comment as dealt with, or put it back

Body:

- `comment_id` (string) **required**
- `handled` (boolean)

Answers: `200` Every comment now marked as dealt with.; `422` Failure

### `POST /api/v1/projects/{project_id}/tasks/{id}/link_pr`

Point the task at a pull request that already exists

Body:

- `pr_path` (string) **required**

Answers: `200` The task as it now stands.; `422` Failure

### `POST /api/v1/projects/{project_id}/tasks/{id}/merge_back`

Fold the work back into the base branch on this machine

For changes that are not going through a pull request.

Answers: `200` The branch it was merged into.; `422` Failure

### `POST /api/v1/projects/{project_id}/tasks/{id}/open_pr`

Open a pull request for the task's branch

Answers: `200` The pull request that was opened.; `422` Failure

### `GET /api/v1/projects/{project_id}/tasks/{id}/review_comments`

The code review conversation on the task's pull request

Cached for an hour. Pass `refresh=true` to read GitHub now. Comment ids are strings; `handled_ids` is a private note about which have been dealt with and is never sent to GitHub.

Query parameters:

- `refresh` (boolean)

Answers: `200` The conversation.; `422` `no_pr` when the task has no pull request yet.

### `POST /api/v1/projects/{project_id}/tasks/{id}/run_tests`

Run the project's tests in the task's checkout

A slow request: the suite runs to completion before this answers, and it is allowed up to thirty minutes. Tests that ran and failed are a `200` with `passed` false, not an error; an error here means the suite could not be run at all.

Answers: `200` Whether the suite passed, with the tail of its output.; `422` Failure

### `POST /api/v1/projects/{project_id}/tasks/{id}/ship`

Run the tests and open the pull request only if they pass

Keeps broken work from reaching review. As slow as running the tests.

Answers: `200` The pull request that was opened.; `422` `tests_failed` carries the failing output in `details`.

## Jira

### `POST /api/v1/projects/{id}/reload_teams`

Read this project's Jira teams again

Slow, because teams can only be found by walking tickets, so it happens on request.

Answers: `200` How many teams were found.; `422` Failure

### `GET /api/v1/projects/{project_id}/tasks/board_epics`

The epics still open on the project's board

Query parameters:

- `refresh` (boolean)

Answers: `200` The epics.; `422` Failure

### `GET /api/v1/projects/{project_id}/tasks/fetch_ticket`

One ticket by its key

Query parameters:

- `key` (string, required)

Answers: `200` The ticket.; `422` Failure

### `GET /api/v1/projects/{project_id}/tasks/search_tickets`

Search the project's board for a ticket

A search that looks like a ticket key fetches that ticket directly. Anything else is matched against the board's tickets.

Query parameters:

- `q` (string)
- `assignee` (string)
- `status_id` (string)
- `issue_type` (string)
- `team_id` (string)
- `limit` (integer)

Answers: `200` The matching tickets.; `422` Failure

### `GET /api/v1/projects/{project_id}/tasks/ticket_filters`

The people, statuses and types in use on the project's board

What a ticket search can usefully be narrowed by.

Query parameters:

- `refresh` (boolean)

Answers: `200` The filters.; `422` Failure

### `GET /api/v1/projects/{project_id}/tasks/unassigned_tickets`

The tickets on the board nobody has taken

Query parameters:

- `board` (integer)
- `limit` (integer)

Answers: `200` The unassigned tickets.; `422` Failure

### `POST /api/v1/projects/{project_id}/tasks/{id}/assign_to_me`

Put the task's ticket in your own name

Answers: `200` Who the ticket now belongs to.; `422` Failure

### `POST /api/v1/projects/{project_id}/tasks/{id}/create_ticket`

File a Jira ticket for the task

The task takes the ticket's key, so it is linked from then on.

Answers: `200` The ticket that was filed.; `422` Failure

### `POST /api/v1/projects/{project_id}/tasks/{id}/download_from_ticket`

Bring the ticket's title and description back into the task

Answers: `200` The task as the ticket now has it.; `422` Failure

### `POST /api/v1/projects/{project_id}/tasks/{id}/log_ticket_time`

Add time to what the ticket already shows

Body:

- `time` (string) **required**

Answers: `200` The time the ticket now shows.; `422` Failure

### `PATCH /api/v1/projects/{project_id}/tasks/{id}/set_ticket_time`

Say how long the work took, replacing what was there

Body:

- `time` (string) **required** - A Jira duration.

Answers: `200` The time the ticket now shows.; `422` Failure

### `GET /api/v1/projects/{project_id}/tasks/{id}/ticket_time`

How long the ticket says the work took

Answers: `200` The time the ticket shows.; `422` Failure

### `POST /api/v1/projects/{project_id}/tasks/{id}/upload_to_ticket`

Send the task's title and description to its ticket

Answers: `200` The ticket that was written to.; `422` Failure

## Configuration

### `GET /api/v1/boards`

Every board

A board carries the Jira settings for the work on it, so several projects can share one without repeating its details.

Answers: `200` The boards, by name.

### `POST /api/v1/boards`

Make a board

Body:

- `board` (object, see BoardInput below)

Answers: `201` The board that was made.; `422` Invalid

### `GET /api/v1/boards/jira_boards`

The boards Jira itself knows about

For setting a board up by picking one rather than looking its number up by hand.

Answers: `200` The boards Jira reported.; `422` Failure

### `GET /api/v1/boards/{id}`

One board and the projects on it

Answers: `200` The board.; `404` NotFound

### `PATCH /api/v1/boards/{id}`

Change a board

Body:

- `board` (object, see BoardInput below)

Answers: `200` The board as it now stands.; `422` Invalid

### `DELETE /api/v1/boards/{id}`

Delete a board

Projects on it are kept and simply lose their board.

Answers: `200` Ok

### `GET /api/v1/settings`

The app-wide settings

Each setting says both what was chosen and what is in force, so a deliberate choice can be told from a field left blank. The API token is never included.

Answers: `200` The settings.

### `PATCH /api/v1/settings`

Change the settings

Sending a field as empty puts it back to its built in default.

Body:

- `setting`: `ai_model`, `ai_harness_command`, `ai_harness_session_flag`, `terminal`, `editor_command`, `git_remote`, `git_base_branch`, `jira_site`, `jira_board_number`, `jira_team_id`, `jira_todo_status_id`, `jira_issue_type`

Answers: `200` The settings as they now stand.; `422` Invalid

### `GET /api/v1/tags`

Every tag

Answers: `200` The tags, by name.

### `POST /api/v1/tags`

Make a tag

A colour is picked from the name when none is given, so the same tag always looks the same.

Body:

- `tag`: `name`, `color`

Answers: `201` The tag that was made.; `422` Invalid

### `PATCH /api/v1/tags/{id}`

Change a tag

Body:

- `tag`: `name`, `color`

Answers: `200` The tag as it now stands.; `422` Invalid

### `DELETE /api/v1/tags/{id}`

Delete a tag

Answers: `200` Ok

## Record shapes

### Project

- `id` (string)
- `name` (string)
- `description` (string or null)
- `local_path` (string or null)
- `remote_path` (string or null)
- `location` (string or null) - The local checkout if there is one, otherwise the remote.
- `base_branch` (string) - The branch new work starts from and is merged back into.
- `board_id` (string or null)
- `jira_key` (string or null) - Settled from the project, then its board, then the app settings.
- `jira_board_number` (integer or null)
- `jira_issue_type` (string or null)
- `has_start_script` (boolean)
- `has_test_script` (boolean)
- `created_at` (string)
- `updated_at` (string)

### ProjectDetailed

Everything in Project, plus:

- `start_script` (string or null)
- `test_script` (string or null)
- `open_tasks_count` (integer)
- `done_tasks_count` (integer)
- `open_pull_requests_fetched_at` (string or null)

### Task

- `id` (string)
- `project_id` (string)
- `title` (string)
- `ticket` (string or null)
- `ticket_url` (string or null)
- `parent_ticket` (string or null) - The epic this task's ticket sits under.
- `parent_ticket_title` (string or null)
- `pr_path` (string or null)
- `worktree_path` (string or null)
- `weight` (integer or null) - The running order, one to five, smallest first. Blank means the task has not been placed yet and goes to the back.
- `done` (boolean)
- `done_at` (string or null)
- `initialized` (boolean) - Whether the task has a checkout of its own yet.
- `assignee` (string or null)
- `tags` (array)
- `agent` (object)
- `created_at` (string)
- `updated_at` (string)

### TaskDetailed

Everything in Task, plus:

- `description` (string or null)
- `notes` (string or null)
- `notes_path` (string or null) - A file the notes live in, kept outside the app.
- `jira_team_id` (string or null)
- `jira_team_name` (string or null)
- `ai_model` (string or null)
- `ai_session_id` (string or null)
- `ai_session_summary` (string or null)
- `ai_session_summarized_at` (string or null)
- `started_project` (boolean)
- `unhandled_review_comment_count` (integer)

### TaskInput

- `title` (string)
- `description` (string)
- `ticket` (string)
- `parent_ticket` (string)
- `parent_ticket_title` (string)
- `pr_path` (string)
- `worktree_path` (string)
- `assignee` (string)
- `jira_team_id` (string)
- `weight` (integer)
- `notes` (string)
- `notes_path` (string)
- `done` (boolean) - Marking a task done records when it was first finished; marking it done again does not move it.
- `tag_names` (string) - A comma separated list, replacing the task's tags. New names are made.
- `new_tag_names` (string) - A comma separated list added on top of the tags already there.
- `tag_ids` (array)

### Agent

What the background AI agent is doing for a task.

- `busy` (boolean)
- `activity` (string or null) - What it is up to, in words.
- `failed` (boolean)
- `error` (string or null)
- `started_at` (string or null)
- `finished_at` (string or null)
- `running_for_seconds` (integer or null)

### Commit

- `sha` (string)
- `subject` (string)
- `author` (string)
- `committed_at` (string)

### RunningServer

- `running` (boolean)
- `port` (integer or null)
- `pid` (integer or null)
- `url` (string or null)
- `unavailable_because` (string or null) - Set when it could not be told either way, as opposed to nothing running.

### Feed

- `project` (object)
- `total` (integer)
- `tasks` (array) - In the order the work should be gone through.

### Board

- `id` (string)
- `name` (string)
- `number` (integer)
- `jira_project_key` (string or null)
- `team_id` (string or null)
- `team_name` (string or null)
- `todo_status_id` (integer or null)
- `issue_type` (string or null)
- `description` (string or null)
- `created_at` (string)
- `updated_at` (string)

### Tag

- `id` (string)
- `name` (string)
- `color` (string)
- `created_at` (string)

### Error

- `error` (string) - A stable machine readable reason. Known values include `unauthorized`, `not_found`, `parameter_missing`, `invalid`, `agent_busy`, `no_session`, `not_initialized`, `missing_worktree`, `no_script`, `tests_failed`, `no_pr`, `unknown_comment`, `no_ticket`, `blank_pr`.
- `message` (string)
- `details` (string) - Output too long for a message, such as a failing test run.
