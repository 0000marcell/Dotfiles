# Dotfiles

my dot files configuration

## Skills

My [Crush](https://github.com/charmbracelet/crush) / Claude skills live in
[`skills/`](skills). Each folder is a skill with a `SKILL.md`.

On this machine `~/.claude/skills/<name>` are symlinks pointing into this
repo, so editing a skill here and running `~/ud` (or `git push`) uploads it.

### Installing the skills on a new computer

```sh
git clone git@github.com:0000marcell/Dotfiles.git ~/Dotfiles
cd ~/Dotfiles
./install_skills.sh
```

The script symlinks every skill in `skills/` into `~/.claude/skills/`
(existing folders are backed up as `<name>.backup`). Restart Crush / start a
new session and the skills are loaded.

To add a new skill: create `skills/<name>/SKILL.md`, symlink it into
`~/.claude/skills` (or re-run `./install_skills.sh`), commit and push.
