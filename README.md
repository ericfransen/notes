# Note-Taking CLI Tool for Obsidian

This repository provides a self-contained, command-line tool for capturing notes.

Just type `note` on the CLI to quickly launch a markdown note in your editor of choice that integrates with Obsidian.  

Your note is saved to your vault and automatically backed up to a **separate, private GitHub repo**.

## Additional Justification

This utility is designed for the power user who lives in the terminal.

It decouples the essential task of capturing new knowledge from the context of the Obsidian application, solving the greatest source of friction in any Personal Knowledge Management (PKM) workflow.

### Key Benefits of This CLI Solution

- Features (CLI Value Proposition)
    - Zero-Latency Capture
        - Capture a complete, structured thought with a single command without leaving your console or IDE. Eliminates context switching. Your thought is saved instantly, maintaining flow state (adhering to Zettelkasten's fleeting note principle).
    - Structured In-Capture
        - Automatically applies the required YYYY-MM-DD_HH-MM timestamp, YAML Frontmatter (Properties), and the status: inbox flag.
        - Forces consistency at the source. Your note is pre-formatted for later Dataview queries.
    - Intelligent Routing
        - Use simple flags (note "bug fix" #project-a) to automatically create the correct subdirectory and populate the keywords property.
        - Automated triage: new notes are filed into their review category immediately (automating 1st step of the PARA workflow).
    - Direct Obsidian Launch
        - The `note -obsidian` flag seamlessly switches context, enabling a fast transition from capture to integration/synthesis.
    - Decoupling & Modularity
        - Separates the capture utility from the scheduled, nightly Git backup job.
        - Failures in one stage (capture or sync) do not affect the other.

- Enhanced Workflow: Combining Note CLI Tool & Obsidian Git Plugin
    - While the CLI excels at initial capture, it is inferior for interactive synchronization and managing configuration state.
    - By coupling the two, the CLI handles the rapid capture and initial structure, while the plugin handles the advanced, event-driven synchronization needed for real-time collaboration or multi-device operation and settings.

## Core Principle: Your Notes are Private

This system is built on the principle of separating the **tool** (this public repository) from your **data** (your private notes). The setup script will guide you through creating a new, separate, and private Git repository for your notes, ensuring you never accidentally commit personal data to a public fork, or syncing with an existing private notes repo.

## Features

- **Secure by Default**: The setup process guides you to create a separate, private repository for your notes.
- **Automated Repo Creation**: If you have the GitHub CLI (`gh`) installed, the setup script can automatically create a private repository on GitHub for you.
- **Self-Contained**: All scripts and configuration live within this single repository.
- **Smart Sync**: An optional local cron job syncs changes to your private notes repository at 11:59 PM local time, but only if notes were changed that day.

## Prerequisites

1.  **(Recommended) GitHub CLI**: For a fully automated setup. Install it from [cli.github.com](https://cli.github.com).
2.  **(Recommended) VS Code `code` command**: For opening notes in an editor, although you can specify your own editor command in the config file.

## Installation

1.  Clone or fork this repository to a permanent location on your computer.

2.  Navigate into the project directory:
    ```sh
    cd /path/to/note-system
    ```

3.  Make the setup script executable:
     ```sh
     chmod +x scripts/setup.sh
     ```

4.  Run the interactive setup script:
    ```sh
    bash scripts/setup.sh
    ```

> **Note**: You can run the following script at any time to install or repair the global command symbolic links:
    ```sh
    bash scripts/install.sh
    ```

## How It Works

 **Create a Note**:
    The `note` command has several flags and modes:

   **Create an Atomic Note**: `note "My atomic note" #idea`
   **Create a Note in Editor (Focus Mode)**: `note #idea`
    -   Opens just the single new file for distraction-free writing.
   **Create a Note in Editor (Context Mode)**: `note -v #idea`
    -   The `-v` flag opens the entire vault in VS Code, with your new note active. Use this when you want to search other notes or see the file tree.
   **Create a Daily Note**: `note -daily` (can also be combined with `-v`)

   **Reconfigure Vault**: `note -vault`
   **Open Vault in VS Code**: `note -code`
   **Open Vault in Obsidian**: `note -obsidian`
   **Setup Git Remote**: `note -git-setup`
    -   The `-v` flag opens the entire vault in VS Code, with your new note active. Use this when you want to search other notes or see the file tree.
   **Create a Daily Note**: `note -daily` (can also be combined with `-v`)

   **Nightly Cron Job (Optional)**:
    - You are able to set up a backup to GitHub of your notes vault as part of initial `setup` script

    - Every time the nightly sync job runs, before it commits any changes, it will first search for and delete any "blank" notes. A note is considered blank if it meets both of these conditions:
        - 1. Its title is still the default untitled.
        - 2. Its body section is completely empty.

    - You will need to set up a Personal Access Token (PAT) for scheduled notes backup
        - Go to your GitHub Settings → Developer settings → Personal access tokens → Tokens (classic).
        - Scope Selection (Minimum Required):
            - For creating repositories: check the `repo` scope (full control of private repositories).
            - For pushing code (per the cron job): the `repo` scope covers this.
            - Also `read:org`
            - Note: Set a clear expiration date (e.g., 1 year) and provide a descriptive name like "Obsidian-CLI-Cron."

        - When prompted by `gh auth login`, choose Paste the authentication token.

        - The GitHub CLI will store this token securely in your user's configuration file (~/.config/gh/hosts.yml). When your cron job runs the note script, which then
calls `git push` or `gh repo create`, the GitHub CLI will retrieve and use this token automatically.

## Setting Up on a New Computer

This system is designed to work with an existing notes vault that is already tracked in a private Git repository.

1.  **Clone Your Notes Vault**: On your new computer, first clone your private notes vault from GitHub:
    `git clone <your-private-notes-repo-url> ~/notes-vault`
2.  **Clone the Tool**: Next, clone this `note-system` repository somewhere else:
    `git clone <this-tool-repo-url> ~/note-system`
3.  **Run Setup**: Navigate into the `note-system` directory and run the setup script:
    `cd ~/note-system && bash scripts/setup.sh`
4.  **Select Your Vault**: When prompted, choose the option to manually enter the path to your vault and provide the location where you cloned it (e.g., `~/notes-vault`).

The script will automatically detect that your vault is already a Git repository with a remote configured and will skip all the creation steps, seamlessly connecting your tools to your existing notes.

## How It Works

This system provides a single main script, `note`, with several commands and flags. For a full list of commands and what they do, please see [COMMANDS.md](./COMMANDS.md).

## Troubleshooting

If your nightly sync fails, you can check the log file at `.sync_log` in this project's directory.

- **Error: "Your local branch is behind the remote"**: This means another one of your devices has pushed changes to GitHub. To fix this, navigate to your vault directory in the terminal and run `git pull`.
- **Error: "Merge conflict detected"**: This can happen after a `git pull` if you and another device have edited the same lines in the same file. To fix this, open your vault folder in a code editor like VS Code, find the file(s) with conflict markers (`<<<<<`, `>>>>>`), edit them to resolve the conflict, and then manually commit the changes.
