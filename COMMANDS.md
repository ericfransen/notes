# `note` Script Command Glossary

This file provides a quick reference for all the available commands and flags for the `note` script.

## Main Commands

- `note "Some text"`
  - Creates an "atomic note" instantly. The text is the body of the note.

- `note #keyword`
  - Creates a new note in the editor, filed under the `keyword` subdirectory and tagged with `keyword`.

- `note -daily`
  - Finds or creates the note for the current day in your designated daily notes folder.

## Flags & Options

These can be combined with the main commands (e.g., `note -v #project`).

- `-v`
  - Opens the new note in "vault context". This opens your entire vault folder in the editor with the new note active, giving you access to the file tree and vault-wide search.

## Utility Commands

- `note -vault`
  - Starts the interactive process to find and set the path to your Obsidian vault.

- `note -code`
  - Opens your entire vault folder in your configured editor (e.g., VS Code).

- `note -obsidian`
  - Opens your vault in the Obsidian application.

- `note -git-setup`
  - Starts the process to create and link a private GitHub repository for backing up your notes vault.

- `note -sync-status`
  - Checks if the automatic nightly sync (cron job) is installed and shows the last time it ran.
      - Cron Schedule: Schedule: 59 23 * * * /usr/local/bin/note-sync
        - This line is the definition of your automatic nightly backup, using a standard scheduling format called "cron":
            - 59: At minute 59 past the hour.
            - 23: During hour 23 of the day (i.e., 11 PM).
            - *: On every day of the month.
            - *: In every month.
            - *: On every day of the week.

- `note -debug`
  - Prints a detailed report of the script's internal configuration, paths, and variables to help diagnose issues.

## Command Examples

- `note`
  - Launches the code editor for a new note (markdown file) in your default inbox (00 - Inbox).

- `note "My atomic note"` - saves new atomic note
  - Instantly saves a new atomic note with that content to your inbox. No editor is launched.

- `note "My atomic note" #idea #foo`
  - Instantly saves a new atomic note. The #idea tag places the note in an idea/ subdirectory and adds idea to the note's frontmatter
      keywords.
    - The first tag determines the location: The note will be placed in a subdirectory named after the first tag you provide: /idea.
    - All tags are recorded: Both `idea` and `foo` will be added to the note's metadata (the YAML frontmatter), like this: keywords: idea,foo.  This allows you to file the note under its primary category while still tagging it with multiple relevant keywords for Obsidian to track.

- `note #idea`
  - Launches the code editor for a new note, but places it in the idea/ subdirectory and adds the keyword.
