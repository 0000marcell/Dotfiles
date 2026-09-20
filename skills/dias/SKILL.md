---
name: dias
description: "GitHub PR monitoring tool for tracking open pull requests across configured repositories. Use when the user asks about PRs, pull requests, repo activity, what's open, what needs review, or wants a status report on their GitHub projects."
---

# DIAs Skill

Use this skill when the user asks about GitHub pull requests, PR status, open PRs, repository activity, or wants to check what's happening across their monitored repos.

## Location

DIAs is installed at `/home/mmc/dias/`.

## Configuration

Repositories are configured in `/home/mmc/dias/projects.toml`. Each repo can have:
- `name` - GitHub repo in `org/repo` format
- `priority` - 1 (highest) to N (lower). Default is 1.
- `version_file` - Path to version file for `--details` output

The `[ignore]` section can filter out authors (e.g., dependabot).

## Commands

Run all commands from `/home/mmc/dias/` using `uv run dias`.

### Basic Report

```bash
cd /home/mmc/dias && uv run dias report
```

Shows only priority 1 repos by default.

### Show All Repos

```bash
cd /home/mmc/dias && uv run dias report --all
```

### Priority Filtering

```bash
uv run dias report                # Priority 1 only (default)
uv run dias report --priority 2   # Exactly priority 2
uv run dias report --level 3      # Priority 1, 2, and 3
uv run dias report --below 1      # Priority 2 and lower
uv run dias report --all          # All repos
```

### Filter by Project

```bash
uv run dias report --projects elsa          # Repos containing "elsa"
uv run dias report --projects ".*-api$"     # Repos ending in "-api"
```

### Filter by Author

```bash
uv run dias report --author alice           # PRs by alice
uv run dias report --author "alice|bob"     # PRs by alice or bob
```

### Show Details

```bash
uv run dias report --details
```

Adds Jira status, version, and review status to each PR.

### Recently Closed PRs

```bash
uv run dias report --recent           # Include closed PRs from last 7 days
uv run dias report --recent 14        # Include closed PRs from last 14 days
uv run dias report --closed           # Show ONLY closed PRs (last 7 days)
uv run dias report --closed --recent 14  # Show ONLY closed PRs (last 14 days)
```

### Combined Filters

```bash
uv run dias report --projects elsa --author kluzny --details
uv run dias report --all --recent --details
```

### Other Options

```bash
uv run dias report -v      # Verbose (INFO level)
uv run dias report -vv     # Debug level
uv run dias report --no-color  # Disable colors
```

## Output

The report shows for each repo:
- Repo name and GitHub link
- Description
- Number of open PRs (and ignored count if applicable)
- Each PR with: title, PR number, author, date, GitHub link, and Jira link if detected

## Requirements

- `gh` CLI authenticated (`gh auth login`)
- `acli` for Jira integration with `--details` (`acli auth login`)
