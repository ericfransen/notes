# Note-Taking CLI Tool for Obsidian

This repository provides a self-contained, command-line tool for capturing notes. It is designed to be cloned or forked publicly, while helping you manage your personal notes in a **separate, private repository**.

## Core Principle: Your Notes are Private

This system is built on the principle of separating the **tool** (this public repository) from your **data** (your private notes). The setup script will guide you through creating a new, separate, and private Git repository for your notes, ensuring you never accidentally commit personal data to a public fork.

## Features

- **Secure by Default**: The setup process guides you to create a separate, private repository for your notes.
- **Automated Repo Creation**: If you have the GitHub CLI (`gh`) installed, the setup script can automatically create a private repository on GitHub for you.
- **Self-Contained**: All scripts and configuration live within this single repository.
- **Smart Sync**: An optional local cron job syncs changes to your private notes repository at 11:59 PM local time, but only if notes were changed that day.

## Prerequisites

1.  **Git**: Required for version control.
2.  **(Recommended) GitHub CLI**: For a fully automated setup. Install it from [cli.github.com](https://cli.github.com).
3.  **VS Code `code` command**: For opening notes in an editor.

## Installation

1.  Clone or fork this repository to a permanent location on your computer (e.g., `~/Git/note-system`).
2.  Navigate into the directory:
    ```sh
    cd /path/to/note-system
    ```
3.  Make the setup script executable:
    ```sh
    chmod +x setup.sh
    ```
4.  Run the interactive setup script:
    ```sh
    ./setup.sh
    ```
5.  (Optional) If you were unable to auto gen your remote private GitHub notes repo, you can run:
    ```sh
    note -git-setup
    ```
    <!-- Ensure you have  -->

## How It Works

-   **Create a Note**:
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

    **Nightly Cron Job**:
    - Every time the nightly sync job runs, before it commits any changes, it will first search for and delete any "blank" notes. A note is
  considered blank if it meets both of these conditions:
        - 1. Its title is still the default untitled.
        - 2. Its body section is completely empty.

-   **Reconfigure Vault**: `note -vault`
-   **Setup Git Remote**: `note -git-setup`
-   **Open Obsidian**: `note -obsidian`