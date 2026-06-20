# Smart Backup — Replication Runbook

Replicate this backup system on any Ubuntu/Debian machine.

## Prerequisites

- rsync (`sudo apt install rsync`)
- notify-send (`sudo apt install libnotify-bin`) — optional, for desktop notifications
- systemd with user services (`loginctl enable-linger $USER`)
- External drive (NTFS/ext4/exFAT) with a known label (default: `BACKUP`)

## Steps

### 1. Copy project files

```bash
mkdir -p ~/antigravityapps/smart-backup/state
# Copy these files from the source machine:
#   backup.sh, control.sh, config.sh
scp source-machine:~/antigravityapps/smart-backup/*.sh ~/antigravityapps/smart-backup/
chmod +x ~/antigravityapps/smart-backup/backup.sh ~/antigravityapps/smart-backup/control.sh
```

### 2. Edit config.sh

```bash
nano ~/antigravityapps/smart-backup/config.sh
```

Change these values to match the new machine:
- `DRIVE_LABEL` — label of your backup drive (check with `lsblk -o NAME,LABEL`)
- `SYNC_SUBDIR` — subfolder name on the drive (default: `home-sync`)
- `INTERVAL` — sync frequency in seconds (default: 7200 = 2 hours)
- `MAX_LOAD` — skip threshold (default: 2.0)
- `LIGHT_THRESHOLD` / `HEAVY_THRESHOLD` — size boundary between light and heavy (default: 10M)
- `MAX_CONSECUTIVE_FAILS` — how many failures before beep alert (default: 3)
- `BEEP_INTERVAL` — seconds between beeps when alerting (default: 60)

### 3. Create ~/.syncignore

```bash
nano ~/.syncignore
```

One pattern per line, `#` for comments. Recommended starting point:

```
node_modules/
venv/
.venv/
__pycache__/
.cache/
.git/
dist/
build/
snap/
*.iso
.env
```

Per-folder ignores: drop a `.syncignore` in any subfolder to exclude paths within it.

### 4. Create the CLI symlink

```bash
mkdir -p ~/bin
ln -sf ~/antigravityapps/smart-backup/control.sh ~/bin/backup
grep -q 'HOME/bin' ~/.bashrc || echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 5. Test with dry run

```bash
backup dry
```

Review output. Nothing is written yet.

### 6. Run first sync manually

```bash
backup now
```

Watch the log:
```bash
backup log 50
```

### 7. Install systemd service

```bash
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/smart-backup.service << 'EOF'
[Unit]
Description=Smart Backup Daemon
After=default.target

[Service]
Type=simple
ExecStart=/bin/bash /home/YOUR_USER/antigravityapps/smart-backup/backup.sh daemon
Restart=on-failure
RestartSec=60

[Install]
WantedBy=default.target
EOF

# Replace YOUR_USER
sed -i "s/YOUR_USER/$USER/g" ~/.config/systemd/user/smart-backup.service

systemctl --user daemon-reload
systemctl --user enable --now smart-backup.service
```

### 8. Enable linger (survive logout)

```bash
sudo loginctl enable-linger $USER
```

### 9. Verify

```bash
backup status
systemctl --user status smart-backup
```

## Daily usage

```
backup              Show all commands (help)
backup status       Daemon state, last run, drive, failures
backup now          Sync: light files now, heavy when idle
backup force        Sync everything now, ignore load
backup dry          Preview what would sync (no changes)
backup start        Start background daemon
backup stop         Stop background daemon
backup log [N]      Last N lines of log (default 30)
backup progress     Current sync pass progress
backup ack          Silence beep alert after failures
backup fails        Show failure count + alert state
backup config       Show full configuration
```

## How sync works

1. **Pass 0** — creates entire folder structure on target (instant)
2. **Pass 1** — syncs light files (≤10MB) immediately
3. **Pass 2** — syncs heavy files (>10MB) only when system load drops below threshold

Between runs, the daemon checks if any files changed since last sync. If nothing changed, it skips entirely.

## .syncignore syntax

Same as .gitignore:
```
# Comment
node_modules/     # directory pattern
*.log             # glob
!important.log    # negate (force include)
```

Place in `~/.syncignore` for global rules, or in any subfolder for local rules.

## Alerts

After 3 consecutive sync failures (drive missing, rsync error), the daemon:
- Sends a desktop notification
- Beeps every 60 seconds until acknowledged

Silence with `backup ack`. The daemon keeps retrying regardless.

## Troubleshooting

- **"Drive not found"** — plug in the drive, check `lsblk -o NAME,LABEL,MOUNTPOINT`
- **"Another backup running"** — check `backup progress`, or `rm ~/.backup-daemon/state/lock`
- **Beeping won't stop** — run `backup ack` from any terminal
- **Daemon won't start** — check `journalctl --user -u smart-backup -n 50`
- **Slow first sync** — first run syncs everything; subsequent runs are incremental
- **Wrong drive detected** — check `DRIVE_LABEL` in config.sh matches `lsblk -o LABEL`
- **Files not syncing** — check `~/.syncignore` and per-folder `.syncignore` files
- **No changes detected but files changed** — detection scans 3 levels deep; deeper changes sync on next forced run
