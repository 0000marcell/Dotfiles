# rhumio API reference

Use this when the helper script is not enough — custom aggregation handling,
multi-query analysis, or post-processing in Ruby.

## Inline script template

```bash
cd /home/mmc/rhumio && bundle exec ruby -e '
require_relative "lib/rhumio"
humio = RHumio.new(dotenv: ".env")

result = humio.tail("application_name=\"elsa\" level=\"ERROR\"", limit: 50, start: "24h")

if result.success?
  result.value!.group_by { |e| e["@host"] }.each do |host, events|
    puts "#{host}: #{events.length}"
  end
else
  warn result.failure.inspect
end
'
```

## Construction

```ruby
RHumio.new                                  # .env in cwd, then ENV, then defaults
RHumio.new(dotenv: "/home/mmc/rhumio/.env") # explicit env file
RHumio.new(repository: "decisiv")           # override HUMIO_REPO
RHumio.new(dotenv: nil, token: "...")       # ENV only
```

Resolution order per setting: keyword argument, `ENV`, `.env`, default.

## Instance methods

Every method returns `Dry::Monads::Result`.

| Method | Returns |
|---|---|
| `validate_connection` | `Success(true)` when `/api/v1/status` is ok |
| `search(q, start:, end_at:, timezone:)` | `Success([Event])` synchronously |
| `tail(q, limit:, start:)` | `search` with `\| tail(limit)` appended |
| `search_async(q, start:, poll_interval:, timeout:)` | `Success([Event])` via a query job |
| `repository(name = nil)` | `Success(Repository)`, defaults to `HUMIO_REPO` |
| `repositories` | `RepositoryRegistry` (cached `.all`, `.find_by`, `.reload`) |

## Event

| Method | Description |
|---|---|
| `event[:field]` / `event["field"]` | Field access |
| `event.timestamp` | `Time` from `@timestamp` / `@ingesttimestamp` |
| `event.message` | `@rawstring`, `message` or `msg` |
| `event.to_h` | Full field hash — use this to discover available fields |

Discover the schema of an unfamiliar service:

```ruby
humio.tail("application_name=\"foo\"", limit: 1, start: "24h")
     .fmap { |events| puts events.first.to_h.keys.sort }
```

## Query jobs

Needed when a synchronous query would exceed the server limit.

```ruby
repository = humio.repository.value!
query = RHumio::Query.new(query_string: "application_name=\"elsa\"", start: "30d")
job = repository.start_job(query).value!

job.poll                      # Success({"done" => false, ...})
job.wait(timeout: 600)        # Success([Event]) or Failure[:timeout, ...]
job.cancel
```

## Failure handling

Failures are `[type_symbol, message]` pairs.

| Symbol | Meaning | Action |
|---|---|---|
| `:missing_token` | No token configured | Ask user to populate `.env` |
| `:missing_repository` | No repo given and no default | Pass `--repo` or set `HUMIO_REPO` |
| `:authentication_error` | HTTP 401/403 | Token expired or lacks view access |
| `:not_found` | HTTP 404 | Repository/view name is wrong |
| `:invalid_query` | Empty query or HTTP 400 | Fix query syntax |
| `:api_error` | Other non-2xx | Report the message verbatim |
| `:parse_error` | Malformed body | Usually a partial response; retry |
| `:connection_error` | Socket/timeout | Network or Humio outage |
| `:timeout` | Job did not finish | Raise `timeout:` or narrow the range |
| `:unhealthy` | Status endpoint not ok | Humio side problem |

## Composing with do notation

```ruby
class ErrorReport
  include Dry::Monads[:result, :do]

  def call(humio)
    repository = yield humio.repository
    events = yield repository.tail("level=\"ERROR\"", limit: 200, start: "24h")

    Success(events.group_by { |event| event["job"] })
  end
end
```

## Maintenance

```bash
cd /home/mmc/rhumio && bundle exec rake   # tests + rubocop
```
