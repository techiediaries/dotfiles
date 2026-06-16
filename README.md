# dotfiles

Personal shell configuration, aliases, and runbooks. Clone this on any new machine to get up and running fast.

---

## The problem this solves

When you work on many projects and switch between them daily, memory becomes the bottleneck. You forget folder names, forget paths, forget the bash commands to find things. File explorers show you a tree you have to navigate. VSCode's recent list gets long and hard to scan.

This repo collects tools that remove the memory requirement. Single-letter commands, fuzzy search, zero configuration after setup. The goal: spend zero mental energy getting to your work so you can spend it on the work itself.

---

## What's included

- `bashrc/` — shell functions and aliases
- `runbooks/` — step-by-step setup guides for repeating on any machine

---

## Quick setup on a new machine

```bash
git clone https://github.com/techiediaries/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

---

## Manual setup

If you prefer to pick and choose:

**Project launcher (`p` command):**
```bash
cat bashrc/project-launcher.sh >> ~/.bashrc
source ~/.bashrc
```

See [runbooks/project-launcher-setup.md](runbooks/project-launcher-setup.md) for full setup including fzf install.

---

## Adding new tools

1. Add the shell function or alias to a file in `bashrc/`
2. Add a runbook in `runbooks/` explaining how to set it up from scratch
3. Update `install.sh` to include the new file
4. Push to GitHub
