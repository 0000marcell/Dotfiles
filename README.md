# Dotfiles

my dot files configuration

## Crush

My [Crush](https://github.com/charmbracelet/crush) setup is fully versioned here:

- [`crush/`](crush) — `crushrc` and `crush.json`, symlinked to `~/.config/crush`.
- [`skills/`](skills) — one folder per skill, each symlinked into `~/.claude/skills`.

No secrets live in this repo. `crush.json` only references environment variable
names (e.g. `$FIGMA_API_KEY`); the actual values stay in your shell environment.
Crush's local state (`~/.local/share/crush`: database, sessions, provider
credentials) is machine-owned and deliberately not tracked.

### Installing on a new computer

```sh
git clone git@github.com:0000marcell/Dotfiles.git ~/Dotfiles
cd ~/Dotfiles
./install.sh         # links crush/ and the other app configs into ~/.config
./install_skills.sh  # links every skill into ~/.claude/skills
```

Existing config folders are backed up as `<name>.backup`. Restart Crush / start
a new session and the skills are loaded.

### Adding a new skill

Create it inside this repo so it gets pushed:

```sh
mkdir -p ~/Dotfiles/skills/<name>
$EDITOR ~/Dotfiles/skills/<name>/SKILL.md
./install_skills.sh
```

Then run `~/ud` to commit and push.

> Never create a skill directly in `~/.claude/skills/` — it would be a real
> folder instead of a symlink and would never reach this repo. Run
> `./check_skills.sh` to detect any that drifted.
