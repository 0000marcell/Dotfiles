---
name: anki-cards
description: "Create, organize, and migrate Anki flashcards using ranki. Use when the user wants to create flashcards from docs/notes/codebases/topics, build or restructure Anki decks and sub-decks, group or move existing cards between decks, or turn a markdown file into cards. Triggers: anki, flashcards, ranki, deck, cards about X."
---

# Anki Cards Skill (ranki)

Create and organize Anki flashcards through the ranki gem at `/home/mmc/ranki`.
Every task ends with a reusable, idempotent Ruby script saved in `/home/mmc/ranki/`
named `create_<topic>_cards.rb`, plus verification of the final deck state.

## Prerequisites

- Anki must be running with the AnkiConnect addon (code 2055492159, HTTP on port 8765).
- Always start scripts with `anki.validate_connection` and exit with a message on failure.

## Card style rules

- Question and answer as short as possible: one line question, one short phrase/sentence answer.
- Group cards into topic sub-decks (`Parent::Child::Topic`), never dump everything into one flat deck.
- Tag every card with the topic slug (e.g. `hotwire`, `doom`, `ai-harness`, `personal`).
- Skip ideas that already exist as cards (ranki skips exact-duplicate fronts; avoid near-duplicates by reading existing notes first).
- Research from authoritative docs; if a site 403s (e.g. doomwiki.org), fetch via `web.archive.org`.

## Workflow

1. **Inspect first.** Dump existing notes of the target deck before creating/moving anything:
   ```ruby
   client = anki.deck.find_by(name: "Deck").value!.instance_variable_get(:@client)
   ids = client.invoke("findNotes", { query: "deck:\"Deck\" -deck:\"Deck::*\"" }).value!
   infos = client.invoke("notesInfo", { notes: ids }).value!
   ```
   - `deck:"X"` INCLUDES sub-decks; use `-deck:"X::*"` to get only the parent's own notes.
   - The user's older notes use model `HTML` with fields `Frente`/`Verso`; ranki creates
     notes with model `Basic-9deb5` (`Front`/`Back`). Read both field names when dumping.
     Strip HTML tags to review content.
2. **Design topics** as sub-decks; map every existing note id to a topic (MOVE_MAP).
3. **Gather content**: read the source (file, codebase, web docs) and distill into short Q/A pairs.
4. **Write the script** in `/home/mmc/ranki/create_<topic>_cards.rb` following the template in
   `scripts/template.rb` (next to this SKILL.md).
5. **Run and verify**: `cd /home/mmc/ranki && ruby -c <script> && ruby <script>`, then count notes
   per deck with the query above. Parent deck should end empty when grouping.

## ranki API quick reference

```ruby
require_relative "lib/ranki"
anki = RAnki.new
anki.validate_connection                       # Result
anki.deck.create(name: "Topic", folder_path: "Parent::Child")  # creates Parent::Child::Topic
anki.deck.find_by(name: "Parent::Child::Topic")               # exact, case-insensitive
deck.note.create(front:, back:, tags: [])      # Failure[:invalid_note] on duplicate
```

## Raw AnkiConnect calls (client.invoke returns dry-monads Results)

```ruby
client = deck.instance_variable_get(:@client)
client.invoke("findNotes", { query: ... })
client.invoke("notesInfo", { notes: [id] })    # info["cards"], info["fields"], info["modelName"]
client.invoke("changeDeck", { cards: [card_ids], deck: "Target::Deck" })
client.invoke("deleteNotes", { notes: [note_ids] })
client.invoke("deleteDecks", { decks: ["Deck"], cardsToo: true })
client.invoke("deckNames")
```

## Gotchas (learned the hard way)

- **Moving notes between decks**: there is no note-move action. Get card ids via `notesInfo`
  (`info["cards"]`) and call `changeDeck`. This PRESERVES review history; never delete+recreate.
- **deleteDecks requires `cardsToo: true`** even for empty decks (Anki >= 2.1.28 refuses otherwise).
  Verify the deck is empty with `findNotes` first.
- **Renaming a parent deck**: AnkiConnect has no rename; create the new deck tree, move cards of
  every sub-deck, then delete old decks (children first, `cardsToo: true`).
- **Idempotency**: always handle `deck.create` failure by falling back to `find_by`, and count
  duplicate-skipped cards instead of crashing.
- Run scripts with plain `ruby` from `/home/mmc/ranki` (ddtrace warnings on stderr are harmless,
  filter with `grep -v ddtrace`).

## Existing scripts to reuse as examples

- `create_hotwire_cards.rb` — topic decks + MOVE_MAP + cards from web docs.
- `create_ai_harness_cards.rb` — many topic decks from a codebase exploration.
- `create_doom_keys_exit_cards.rb` — deck move between top-level parents + per-item cards.
- `create_personal_topics_cards.rb` — grouping an existing flat deck into topics.
