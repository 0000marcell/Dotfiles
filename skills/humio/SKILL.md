---
name: humio
description: "Query application logs from Humio / CrowdStrike LogScale using the rhumio Ruby gem. Use when the user asks to look at logs, search logs, investigate errors in production/staging/QA, check what a job or worker did, trace a request or task id, tail an application, or diagnose an incident from log data. Triggers: humio, logscale, logs, log search, production errors, elsa logs, worker logs, why did job X fail."
---

# Humio / LogScale Log Queries

Query logs through the `rhumio` gem instead of hand-rolling curl calls. The `bash`
tool cannot run `curl`, so the gem is the only working path to the API.

## Setup

| Item | Value |
|---|---|
| Gem location | `/home/mmc/rhumio` |
| Helper script | `~/.claude/skills/humio/scripts/humio_query.rb` |
| Token | Fetched by running `HUMIO_TOKEN_COMMAND`, defaulting to the system keyring |
| Other config | `/home/mmc/rhumio/.env` (`HUMIO_URL`, `HUMIO_REPO`) |
| UI | `https://cloud.humio.com/decisiv/search` |

Never print the token. If a query fails with `missing_token` or
`authentication_error`, the token needs replacing: get a new one from
`https://cloud.humio.com/settings/tokens` and save it with

```bash
secret-tool store --label="Humio API token" service humio username default  # Linux
security add-generic-password -s humio -a default -w -U                     # macOS
```

To read the token from a password manager instead, set `HUMIO_TOKEN_COMMAND`
to a command that prints it, e.g. `pass show humio/api-token`.

## Running a query

Always invoke the helper via `bundle exec` from the gem directory:

```bash
cd /home/mmc/rhumio && bundle exec ruby ~/.claude/skills/humio/scripts/humio_query.rb \
  'application_name="elsa" environment="prod" level="ERROR"' --start 24h --limit 50
```

Options:

| Flag | Purpose |
|---|---|
| `--start` | Range start, relative (`30m`, `24h`, `7d`) or absolute. Default `1h` |
| `--end` | Range end. Default `now` |
| `--limit N` | Appends `\| tail(N)`; always set this for raw event queries |
| `--format` | `text` (default), `json`, `tsv` |
| `--fields` | Comma-separated fields to project, e.g. `@host,level,message` |
| `--async` | Use a query job; **required** for ranges wider than ~1 day |
| `--repo` | Override the repository/view from `.env` |

For anything beyond the helper's shape (aggregations you want to post-process,
multi-step analysis), write an inline Ruby script — see `references/api.md`.

## Query language essentials

```
application_name="elsa" environment="prod" level="ERROR"   # field filters, ANDed
"connection reset"                                          # free-text substring
@host=/^elsa-worker/                                        # regex on a field
level!="INFO"                                               # negation
| tail(100)                                                 # newest N (always end with this)
| head(100)                                                 # oldest N
| groupBy(@host)                                            # counts per host
| groupBy(level, function=count())                          # explicit aggregate
| timechart(span=1h, series=level)                          # bucketed counts
| sort(field=_count, order=desc, limit=20)
```

Pitfalls:

- A bare word like `elsa` is a **substring match on the raw line**, not a field
  filter. It matches unrelated services. Prefer `application_name="elsa"`.
- Without `tail()`/`head()` a broad query can return an enormous payload.
- Synchronous queries time out on wide ranges — switch to `--async`.

## Known log schema (decisiv repo)

Elsa emits structured JSON; these fields are available for filtering:

| Field | Meaning |
|---|---|
| `application_name` | Service name, e.g. `elsa` |
| `environment` | `prod`, `staging`, `qa` |
| `level` | `INFO`, `WARNING`, `ERROR` |
| `job` | Elsa job name |
| `job_config` | Job configuration payload |
| `task_id` | Celery task id — the best key for tracing one execution |
| `application_version` | Deployed git SHA |
| `message` | Log message |
| `@host` | Machine that emitted the line |
| `@timestamp`, `@rawstring`, `@source` | Humio built-ins |

Host naming tells you the role:

| Host prefix | Role |
|---|---|
| `elsa-worker-*` | Celery workers running jobs |
| `elsa-flower-*` | Flower / Tornado web processes (very high volume) |
| `ftp-server-*` | SFTP transfer boxes |
| `case-shoryuken-*`, `case-portal-*` | Adjacent Ruby services |

## Recipes

```bash
# Errors for a service in the last day
'application_name="elsa" environment="prod" level="ERROR"' --start 24h --limit 50

# Everything a single task did, oldest first
'task_id="abc-123"' --start 7d --async --format json

# One job across a week
'job="vmrs_quarterly_system_data" environment="prod"' --start 7d --async --limit 200

# Worker hosts only
'@host=/^elsa-worker/ level!="INFO"' --start 6h --limit 100

# Error volume per host
'application_name="elsa" level="ERROR" | groupBy(@host)' --start 24h --format json

# Hourly error trend
'application_name="elsa" level="ERROR" | timechart(span=1h)' --start 24h --format json
```

## Workflow for an investigation

1. Confirm the failure window and service with the user if not stated.
2. Start narrow: `level="ERROR"` with a small `--limit` over the shortest plausible range.
3. Aggregate to find the shape: `groupBy(@host)` or `groupBy(message)`.
4. Pick one `task_id` and pull its full timeline with `--format json`.
5. Report the root cause with counts, hosts and timestamps. Quote the actual log
   line; do not paraphrase error text.

If a query returns zero events, widen the range or relax field filters one at a
time before concluding nothing happened; a wrong field name silently matches nothing.

## Reference

`references/api.md` — full rhumio API, monadic error handling, async query jobs,
and inline-script examples.
