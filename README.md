<p align="center">
  <img src="assets/icon/icon.png" width="96" alt="Englishbox icon">
</p>

<h1 align="center">Englishbox</h1>

<p align="center">
  An offline English notebook and vocabulary trainer for Hungarian learners.<br>
  Collect words, phrases, grammar rules and sentences,<br>
  and the app reviews them with you at the right time.
</p>

<p align="center">
  <img src="docs/screenshots/today.png" width="200" alt="Today">
  <img src="docs/screenshots/word.png" width="200" alt="Word details">
  <img src="docs/screenshots/review_build.png" width="200" alt="Sentence building">
  <img src="docs/screenshots/progress.png" width="200" alt="Progress">
</p>

---

## Features

### 📥 Collecting
- **Four item types:** word, phrase (idiom, phrasal verb, collocation), grammar rule and sentence. Each has its own colour and form.
- **For words:** pronunciation (IPA) with a scrollable symbol bar, listening (text-to-speech), part of speech and Hungarian meaning.
- **Notes** with formatting: bold, italic, highlight and bullet lists.
- **Example sentences** with the word highlighted. They are also added to review as separate sentences. With the "From my box" button you can link a sentence that's already in your box.
- **Grammar rules** with a pattern (e.g. **If** + past simple + **would** + verb), an explanation, a "Hungarian trap" note, and correct and incorrect examples.
- **Similar words** you can link to each other (the link works both ways), plus tags, source and CEFR level (A1–C2).
- **Quick add** from the Today screen: type something and the app works out whether it's a word, a phrase or a sentence.

<p>
  <img src="docs/screenshots/add_word.png" width="200" alt="New word">
  <img src="docs/screenshots/add_rule.png" width="200" alt="New grammar rule">
  <img src="docs/screenshots/rule.png" width="200" alt="Grammar rule details">
</p>

### 🔁 Review (spaced repetition)
A simplified **SM-2** schedule (like Anki): what you know well comes up less and less often, and what you forget comes back sooner.

- **Word cards:** English to Hungarian and back, with an example sentence and its translation on the back. In Settings you can choose which types appear as word cards (words, phrases and/or grammar).
- **Sentence building** from word tiles, or by typing.
- **Free translation:** your answer is compared with the saved translation, and the words that differ are highlighted.
- **Forgot / Hard / Knew it** ratings. A card you forgot comes up once more at the end of the session.

<p>
  <img src="docs/screenshots/review.png" width="200" alt="Review">
  <img src="docs/screenshots/review_card.png" width="200" alt="Word card">
  <img src="docs/screenshots/review_translate.png" width="200" alt="Free translation">
</p>

### 🚩 Mark to check
Not sure about something? Flag it during review (on the word card) or on the item's page, and add an optional note about what's unclear. The Library shows how many items are waiting to be checked, and one tap lists them all. When you've looked an item up, tap **Done** to remove the flag.

### 🏆 Motivation
- **XP and levels**, a daily **streak** (with an optional "streak freeze") and **daily quests** with XP to claim.
- **Progress:** weekly chart, mastery breakdown, 12-week activity heatmap and 12 badges.
- **Game mode can be turned off.** Then there's no XP, levels or quests, just learning.

### 📚 Organising
- **Library** with search (accent-insensitive, also searches tags) and filters: type, level, tag, collection, favourites and items to check.
- **Collections:** your own collections with an icon, a colour and a "mastered" ratio, item counts per level, and tags.

<p>
  <img src="docs/screenshots/library.png" width="200" alt="Library">
  <img src="docs/screenshots/collections.png" width="200" alt="Collections">
  <img src="docs/screenshots/settings.png" width="200" alt="Settings">
</p>

### ⚙️ Other
- **Fully offline:** all data stays on the phone, in a local SQLite database.
- **Daily reminder** notification (it stays silent if you've already practised that day).
- **Backup and restore** to a JSON file you can share (e.g. to Drive).
- British or American pronunciation, with adjustable speech rate.

---

## Tech stack

| | |
|---|---|
| Framework | Flutter 3.47 · Dart 3.13 · Android only |
| State management | [Riverpod 3](https://riverpod.dev) |
| Navigation | [go_router](https://pub.dev/packages/go_router) (`StatefulShellRoute` for the bottom bar) |
| Database | [drift](https://drift.simonbinder.eu) (SQLite), with live queries |
| Other | flutter_tts, flutter_local_notifications, share_plus, file_picker |
| Font | Lexend |

### Folder structure

```
lib/
├── app/            theme, router, labels, formatting
├── data/           drift database, tables, repositories, providers, backup
├── domain/         pure Dart logic: SRS, XP, levels, streak, quests, badges
├── services/       text-to-speech, reminders
├── widgets/        shared UI components
└── features/       screens: today, add, library, item_detail, review,
                    progress, collections, settings
```

Screens only access the database through the repositories. The business
logic (scheduling, XP, streak) lives in `domain/`, without Flutter.

---

## Running

```
flutter pub get
dart run build_runner build
flutter run
```

`build_runner` generates drift's `db.g.dart`. Run it again whenever the tables
(`lib/data/tables.dart`) change.

Release APK:

```
flutter build apk --release
```

The release build is signed with the key described in `android/key.properties`
(not in git). If that file is missing, the debug key is used instead.

Checks:

```
flutter analyze
```

---

## Importing data

**Settings → Your data → Import backup** loads an Englishbox backup file.
⚠️ Importing **replaces your whole box** (items, progress, XP and settings).
