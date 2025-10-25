# `note` Script Command Glossary

## Main Commands

- `note`
  - Launches the code editor for a new note (markdown file) in your default inbox (00 - Inbox).

- `note "Some text"`
  - Creates an "atomic note" instantly. The text is the body of the note. No editor is launched.

- `note +keyword`
  - Creates a new note in the editor, multiple keywords permitted.

- `note @some-directory`
  - Creates a new note in the editor, filed under the `some-diredctory` subdirectory.

- `note %some-template`
  - Creates a new note in the editor, with the template mapped in the config file to `some-template`.

## Flags & Options

- `-v`
  - Opens the new note in "vault context". This opens your entire vault folder in the editor with the new note active, giving you access to the file tree and vault-wide search.

- `note -daily`
  - Finds or creates the note for the current day in your designated daily notes folder.

- `note -template`
  - Launches a fuzzy search of the template folder for template selection.

- `--key value`
  - Adds structured data to the note's frontmatter. For example, `note "My idea" --source "https://example.com"` will add `source: "https://example.com"` to the YAML properties.

- `--title "some cool title"`
  - Adds title to the note's filename and frontmatter title section.

## Utility Commands

- `note -vault`
  - Starts the interactive process to find and set the path to your Obsidian vault, or open it.

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
