# Frictionless Note-Taking System for Obsidian

This repository provides a self-contained, command-line system for capturing notes directly into an Obsidian vault. It's designed for rapid capture and easy setup. All configuration and scripts live within this single repository.

## Features

- **Self-Contained**: All scripts and configuration live in this repository. No files are sprinkled across your system.
- **Interactive Setup**: A guided setup script (`setup.sh`) to get you running in minutes.
- **Automatic Vault Discovery**: A `note -vault` command to find and configure your Obsidian vault.
- **Local Configuration**: Uses a `config.sh` file within this repo to store your vault path.
- **Smart Sync**: An optional local cron job syncs changes to GitHub at 11:59 PM local time, but only if notes were changed that day.

## How the Smart Sync Works

You asked if the backup job is scheduled only when a change is made. Here’s a breakdown of how it operates:

Think of the cron job like a diligent night watchman who is scheduled to patrol every night at 11:59 PM.

1.  **The Schedule is Fixed**: The watchman **always** starts their patrol at 11:59 PM. The schedule itself doesn't change. This is what the cron job does: it runs the `note-sync` script at the same time every day.

2.  **The Action is Conditional**: During the patrol, the watchman checks a logbook to see if any doors were opened during the day.
    -   If the log is empty (no changes to your notes), the watchman does nothing and ends their shift.
    -   If the log shows activity (you've added or changed notes), the watchman files a report (pushes your changes to GitHub).

So, the job **runs daily**, but it only **takes action** if it detects changes in your vault. This gives you the desired outcome—a backup only happens when needed—while using a simple, reliable scheduling mechanism.

## Installation

1.  Clone or download this repository to a permanent location on your computer (e.g., `~/Git/note-system`).
2.  Navigate into the directory:
    ```sh
    cd /path/to/note-system
    ```
3.  Run the interactive setup script:
    ```sh
    ./setup.sh
    ```
The script will make itself executable and guide you through the rest of the process.

## How to Use

-   **Create a Note**: `note` or `note "My atomic note" #idea`
-   **Reconfigure Vault**: `note -vault`
-   **Open Obsidian**: `note -obsidian`
