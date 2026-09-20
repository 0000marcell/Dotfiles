#!/usr/bin/env ruby
# frozen_string_literal: true

# Template: creates <PARENT>::<topic sub-decks>, optionally moves existing
# notes into topics, and adds short flashcards. Copy, rename to
# create_<topic>_cards.rb, fill in the constants, then:
#   cd /home/mmc/ranki && ruby -c <script> && ruby <script>

require_relative "lib/ranki"

PARENT_DECK = "MyDeck" # e.g. "AI::Harness" or "Personal"

TOPICS = [
  "Topic One",
  "Topic Two"
].freeze

# Existing note ids to move into topic decks (preserves review history).
# Dump them first: findNotes + notesInfo (see SKILL.md).
MOVE_MAP = {
  # "Topic One" => [1_234_567_890_123],
}.freeze

# Short question / short answer, grouped per topic.
CARDS = {
  "Topic One" => [
    { front: "What is X?", back: "Short one-phrase answer." }
  ],
  "Topic Two" => []
}.freeze

TAGS = ["my-topic"].freeze

anki = RAnki.new

unless anki.validate_connection.success?
  puts "Cannot connect to Anki. Make sure Anki is running with AnkiConnect installed."
  exit 1
end

puts "Connected to Anki!"

parent_name = PARENT_DECK.split("::").last
parent_folders = PARENT_DECK.split("::")[0..-2].join("::")
result = anki.deck.create(name: parent_name, folder_path: parent_folders.empty? ? nil : parent_folders)
parent = result.success? ? result.value! : anki.deck.find_by(name: PARENT_DECK).value!

client = parent.instance_variable_get(:@client)

# 1. Create topic sub-decks
decks = {}
TOPICS.each do |topic|
  result = anki.deck.create(name: topic, folder_path: PARENT_DECK)
  decks[topic] = result.success? ? result.value! : anki.deck.find_by(name: "#{PARENT_DECK}::#{topic}").value!
  puts "Using deck: #{decks[topic].name}"
end

# 2. Move existing notes (changeDeck preserves review history)
MOVE_MAP.each do |topic, note_ids|
  target = decks[topic].name
  moved = 0

  note_ids.each do |note_id|
    info_result = client.invoke("notesInfo", { notes: [note_id] })
    next unless info_result.success?

    info = info_result.value!.first
    next if info.nil? || info["cards"].nil? || info["cards"].empty?

    result = client.invoke("changeDeck", { cards: info["cards"], deck: target })
    moved += 1 if result.success?
  end

  puts "Moved #{moved}/#{note_ids.length} notes into #{target}"
end

# 3. Add cards (duplicates are skipped by ranki)
CARDS.each do |topic, cards|
  deck = decks[topic]
  created = 0
  skipped = 0

  cards.each do |card|
    result = deck.note.create(front: card[:front], back: card[:back], tags: TAGS)
    if result.success?
      created += 1
    else
      skipped += 1
      puts "  skipped (#{result.failure.first}): #{card[:front]}"
    end
  end

  puts "Added #{created} cards to #{deck.name} (#{skipped} skipped)"
end

# 4. Verify
TOPICS.each do |topic|
  name = "#{PARENT_DECK}::#{topic}"
  count = client.invoke("findNotes", { query: "deck:\"#{name}\" -deck:\"#{name}::*\"" }).value!.length
  puts "#{name}: #{count} notes"
end

puts "Done!"
