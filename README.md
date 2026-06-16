# dotfiles

Personal shell configuration, aliases, and runbooks. Clone this on any new machine to get up and running fast.

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
