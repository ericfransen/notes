# Frictionless Note-Taking System for Obsidian

This system provides an ultra-lightweight, command-line interface for capturing notes directly into an Obsidian vault. It's designed for rapid, frictionless capture without leaving the terminal, while integrating seamlessly with Obsidian's powerful features like YAML frontmatter and Dataview.

## Features

- **Multiple Capture Modes**: Create notes with a single command, either opening them in an editor or capturing "atomic" notes instantly from a string.
- **Automatic Organization**: Uses hashtags (`#keyword`) to automatically file notes into corresponding subdirectories.
- **YAML Frontmatter Injection**: Automatically populates new notes with structured metadata (`date`, `title`, `keywords`, `status`).
- **VS Code Integration**: Opens new notes directly in Visual Studio Code, positioning the cursor for immediate editing.
- **Obsidian Integration**: Includes a command to launch the Obsidian app and open your vault directly.
- **Automated Git Backups**: A GitHub Actions workflow is provided for nightly, automated backups of your vault to a private or public repository.

## Prerequisites

1.  **Obsidian**: You must have Obsidian installed.
2.  **Obsidian Vault**: A vault created at `~/notes-vault`. The script is configured for this path.
3.  **VS Code Shell Command**: The `code` command must be installed in your system's PATH. You can add this in VS Code by opening the Command Palette (`Cmd+Shift+P`) and running `Shell Command: Install 'code' command in PATH`.

## Installation

1.  **The `note` Script**:
    -   Move the `note` script to a directory in your system's PATH, for example: `mv note /usr/local/bin/`.
    -   Make it executable: `chmod +x /usr/local/bin/note`.

2.  **The Note Template**:
    -   Place the `note_template.md` file inside your Obsidian vault: `mv note_template.md ~/notes-vault/`.
    -   The script requires this template to exist at `~/notes-vault/note_template.md`.

## How to Use the `note` Script

The script offers several modes of operation for maximum flexibility.

### 1. Editor Mode
Simply run the command without arguments. This creates a new note in the default inbox and opens it in VS Code, ready for you to edit the title.

```sh
note
```
- **Action**: Creates `~/notes-vault/00 - Inbox/YYYY-MM-DD_HH-MM_untitled.md`.
- **Result**: The new file is opened in VS Code with the cursor on the `title` property line.

### 2. Atomic Capture Mode
Provide a string as an argument to create a note instantly. The first 80 characters become the title, and the full string becomes the body.

```sh
note "This is an atomic note that I want to capture right now."
```
- **Action**: Creates a new note in `~/notes-vault/00 - Inbox/` with the content pre-filled.
- **Result**: The file is saved, and the script exits. No editor is opened.

### 3. Keyword & Subdirectory Mode
Use a hashtag to specify a keyword. This will create the note in a subdirectory named after that keyword.

```sh
# Create a note in editor mode in the 'ideas' folder
note #ideas

# Create an atomic note and place it in the 'meetings' folder
note "Discuss Q4 roadmap with the team" #meetings
```
- **Action**: Creates the note in `~/notes-vault/ideas/` or `~/notes-vault/meetings/`.
- **Frontmatter**: The `keywords` property in the note will be populated with `ideas` or `meetings`.

### 4. Launch Obsidian
Quickly open your vault in the Obsidian application.

```sh
note -obsidian
```
- **Action**: Launches Obsidian and opens the `notes-vault`.

## Automated Nightly Backups

The `nightly_sync.yml` file provides a GitHub Actions workflow to back up your vault every night.

### Setup

1.  **Initialize a Git Repository**: If you haven't already, initialize a git repository in your vault.
    ```sh
    cd ~/notes-vault
    git init
    git remote add origin YOUR_GITHUB_REPO_URL
    ```
2.  **Create Workflow Directory**: Create the necessary directories for the workflow file.
    ```sh
    mkdir -p ~/notes-vault/.github/workflows
    ```
3.  **Add Workflow File**: Move the `nightly_sync.yml` file into this directory.
    ```sh
    mv nightly_sync.yml ~/notes-vault/.github/workflows/
    ```
4.  **Commit and Push**: Commit the workflow file and push it to your GitHub repository. The workflow will now run automatically at 11:59 PM UTC daily.

### How It Works
- **Scheduled Run**: Triggers automatically every night.
- **Change Detection**: It checks for any file additions, modifications, or deletions. If and only if changes are detected, it creates a commit. This prevents empty commits.
- **File Exclusion**: Before checking for changes, it removes volatile files that shouldn't be in version control, such as `.obsidian/workspace.json` and other `.json` files.
- **Git Identity**: Commits are made by a "NoteBot" user.
