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

## How It Works

The `note` command has several flags and modes:

-   **Create an Atomic Note**: `note "My atomic note" #idea`
-   **Create a Note in Editor (Focus Mode)**: `note #idea`
    -   Opens just the single new file for distraction-free writing.
-   **Create a Note in Editor (Context Mode)**: `note -v #idea`
    -   The `-v` flag opens the entire vault in VS Code, with your new note active. Use this when you want to search other notes or see the file tree.
-   **Create a Daily Note**: `note -daily` (can also be combined with `-v`)
-   **Reconfigure Vault**: `note -vault`

## Additional Justification

This utility is designed for the power user who lives in the terminal. It decouples the essential task of capturing new knowledge from the context of the Obsidian application, solving the greatest source of friction in any Personal Knowledge Management (PKM) workflow.

### Key Benefits of This CLI Solution

- Features (CLI Value Proposition)
    - Zero-Latency Capture
        - Capture a complete, structured thought with a single command without leaving your console or IDE.	Eliminates context switching. Your thought is saved instantly, maintaining flow state.
    - Structured In-Capture
        - Automatically applies the required YYYY-MM-DD_HH-MM timestamp, YAML Frontmatter (Properties), and the status: inbox flag.	
        - Forces consistency at the source. Your note is pre-formatted for later Dataview queries.
    - Intelligent Routing
        - Use simple flags (note "bug fix" #project-a) to automatically create the correct subdirectory and populate the keywords property.
        - Automated triage. New notes are filed into their review category immediately.
    - Decoupling & Modularity
        - Separates the capture utility from the scheduled, nightly Git backup job.
        - Failures in one stage (capture or sync) do not affect the other.

- Enhanced Workflow: Combining Note CLI Tool & Obsidian Git Plugin
    - While the CLI excels at initial capture, it is inferior for interactive synchronization and managing configuration state.
    
    - By coupling the two, the CLI handles the rapid capture and initial structure, while the plugin handles the advanced, event-driven synchronization needed for real-time collaboration or multi-device operation and settings.
