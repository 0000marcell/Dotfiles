#!/usr/bin/env ruby
# frozen_string_literal: true

# Thin CLI over the rhumio gem, used by the `humio` skill.
#
#   humio_query.rb 'application_name="elsa" level="ERROR"' --start 24h --limit 50
#   humio_query.rb 'elsa | groupBy(@host)' --start 1h --format json
#   humio_query.rb 'elsa' --start 7d --async --fields @host,level,message

require "json"
require "optparse"

RHUMIO_PATH = ENV.fetch("RHUMIO_PATH", File.expand_path("~/rhumio"))
require File.join(RHUMIO_PATH, "lib", "rhumio")

options = {
  start: "1h",
  end_at: "now",
  limit: nil,
  format: "text",
  async: false,
  timeout: 300,
  fields: nil,
  dotenv: File.join(RHUMIO_PATH, ".env"),
  repository: nil
}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: humio_query.rb QUERY [options]"
  opts.on("--start START", "Relative or absolute start (default 1h)") { |v| options[:start] = v }
  opts.on("--end END", "End of the range (default now)") { |v| options[:end_at] = v }
  opts.on("--limit N", Integer, "Wrap the query in tail(N)") { |v| options[:limit] = v }
  opts.on("--format FORMAT", %w[text json tsv], "text (default), json, tsv") { |v| options[:format] = v }
  opts.on("--fields LIST", "Comma separated fields for tsv/text output") { |v| options[:fields] = v.split(",") }
  opts.on("--async", "Run as a query job (needed for wide ranges)") { options[:async] = true }
  opts.on("--timeout N", Integer, "Async job timeout in seconds (default 300)") { |v| options[:timeout] = v }
  opts.on("--repo NAME", "Override HUMIO_REPO") { |v| options[:repository] = v }
  opts.on("--env PATH", "Path to the .env file") { |v| options[:dotenv] = v }
  opts.on("-h", "--help") do
    puts opts
    exit 0
  end
end
parser.parse!

query_string = ARGV.join(" ")
if query_string.strip.empty?
  warn parser.banner
  exit 2
end

query_string = "#{query_string} | tail(#{options[:limit]})" if options[:limit]

humio = RHumio.new(dotenv: options[:dotenv], repository: options[:repository])

result =
  if options[:async]
    humio.search_async(query_string, start: options[:start], end_at: options[:end_at],
                                     poll_interval: 2, timeout: options[:timeout])
  else
    humio.search(query_string, start: options[:start], end_at: options[:end_at])
  end

unless result.success?
  type, message = result.failure
  warn "humio #{type}: #{message}"
  exit 1
end

events = result.value!

def selected(event, fields)
  fields ? fields.map { |field| event[field].to_s } : nil
end

case options[:format]
when "json"
  puts JSON.pretty_generate(events.map(&:to_h))
when "tsv"
  events.each do |event|
    row = selected(event, options[:fields]) ||
          [event.timestamp&.iso8601, event["level"], event.message]
    puts row.join("\t")
  end
else
  warn "#{events.length} events"
  events.each do |event|
    if (row = selected(event, options[:fields]))
      puts row.join(" | ")
    else
      puts "#{event.timestamp&.iso8601} #{event["level"]} #{event.message || event.to_h.inspect}"
    end
  end
end
