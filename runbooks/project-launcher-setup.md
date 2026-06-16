# Runbook — Project Launcher Setup (`p` command)

A fuzzy-search project switcher that opens any project in VSCode with one keystroke. Works with any folder on any machine.

---

## The problem this solves

If you work on many projects and switch between them daily, you will eventually hit a wall: you can't remember where everything lives, you forget folder names, and you waste time navigating file explorers or recalling bash commands just to open something you were working on yesterday.

This gets worse the more projects you have. File explorers show you a tree you have to navigate. VSCode's recent files list gets long and hard to scan. Bash commands like `find` and `ls` are powerful but only if you remember them.

The `p` command removes the memory requirement entirely. Type `p`, type any fragment of the name you vaguely remember, and VSCode opens it. You don't need to remember the full name, the exact path, or any command beyond a single letter.

---

## What this does

Type `p` in any terminal → fuzzy-search all subfolders in your projects directory → hit Enter → VSCode opens that project.

No need to remember folder names, paths, or `cd` commands.

---

## Prerequisites

- Ubuntu / Debian-based Linux (see [Other systems](#other-systems) for Mac/other distros)
- VSCode installed with the `code` CLI available in terminal
- All your projects live under one parent folder (e.g. `~/projects/`, `~/work/`, `~/code/`)

---

## Step 1 — Set your projects folder

Replace the path below with wherever your projects actually live:

```bash
export PROJECTS_DIR="$HOME/projects"
```

Every command below uses `$PROJECTS_DIR` — set it once and the rest is copy-paste.

---

## Step 2 — Install fzf

**Ubuntu / Debian:**
```bash
sudo apt install fzf
```

**Mac:**
```bash
brew install fzf
```

**Other Linux:**
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
```

Verify:
```bash
fzf --version
```

---

## Step 3 — Add the `p` command to your shell config

```bash
cat >> ~/.bashrc << EOF

# --- Project launcher ---
# Set this to your projects folder
export PROJECTS_DIR="$PROJECTS_DIR"

# type: p → fuzzy search all projects → opens in VSCode
p() {
  local dir
  dir=\$(ls -d "\$PROJECTS_DIR"/*/ 2>/dev/null | xargs -I{} basename {} | fzf --prompt="project: " --height=40% --reverse)
  [ -n "\$dir" ] && code "\$PROJECTS_DIR/\$dir"
}
EOF
```

> **Mac / zsh users:** replace `~/.bashrc` with `~/.zshrc`

---

## Step 4 — Reload shell

```bash
source ~/.bashrc
```

---

## Step 5 — Test it

```bash
p
```

Start typing any project name → arrow keys to navigate → Enter to open.

Press `Escape` or `Ctrl+C` to cancel without opening anything.

---

## How to use

- `p` — open any project in VSCode
- Start typing to filter by name (e.g. `shop` → shows all folders containing "shop")
- `↑↓` to move, `Enter` to open, `Esc` to cancel

---

## Troubleshooting

**`p: command not found`** — run `source ~/.bashrc` and try again.

**`fzf: command not found`** — Step 2 wasn't completed.

**`code: command not found`** — VSCode's `code` CLI isn't on your PATH. In VSCode: `Ctrl+Shift+P` → "Shell Command: Install 'code' command in PATH".

**No folders appear** — check that `$PROJECTS_DIR` is set correctly: `ls $PROJECTS_DIR`

---

## Full setup on a new machine (copy-paste block)

Set your folder first, then run everything at once:

```bash
PROJECTS_DIR="$HOME/projects"   # ← change this line

sudo apt install fzf             # Ubuntu/Debian; use brew on Mac

cat >> ~/.bashrc << EOF

export PROJECTS_DIR="$PROJECTS_DIR"

p() {
  local dir
  dir=\$(ls -d "\$PROJECTS_DIR"/*/ 2>/dev/null | xargs -I{} basename {} | fzf --prompt="project: " --height=40% --reverse)
  [ -n "\$dir" ] && code "\$PROJECTS_DIR/\$dir"
}
EOF

source ~/.bashrc
```

---

## Other systems

| System | Shell config file | fzf install |
|--------|------------------|-------------|
| Ubuntu / Debian | `~/.bashrc` | `sudo apt install fzf` |
| Mac (zsh) | `~/.zshrc` | `brew install fzf` |
| Mac (bash) | `~/.bash_profile` | `brew install fzf` |
| Arch Linux | `~/.bashrc` | `sudo pacman -S fzf` |
| Fedora | `~/.bashrc` | `sudo dnf install fzf` |
