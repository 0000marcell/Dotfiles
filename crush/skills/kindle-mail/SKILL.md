---
name: kindle-mail
description: Send documents (PDF, EPUB, etc.) to a Kindle through Gmail using the kindle-mail Ruby app and msmtp. Use when the user wants to send, email, or push a book or file to their Kindle, or to set up, check, or fix the msmtp/Gmail/Kindle mail configuration. Triggers: kindle, send to kindle, email book, msmtp, kindle-mail.
---

# kindle-mail

`~/.local/bin/kindle-mail` (source: `~/.local/share/kindle-mail/kindle-mail.rb`) wraps msmtp and Gmail. The Gmail app password lives in the keyring (`secret-tool`, service `email-app`), and `~/.msmtprc` reads it at send time, so no plaintext password is stored on disk.

## Commands

```bash
~/.local/bin/kindle-mail doctor                       # check msmtp, keyring, config
~/.local/bin/kindle-mail setup [--gmail A] [--kindle A] [--new-password]
~/.local/bin/kindle-mail send FILE [--to ADDRESS]     # default recipient: saved Kindle address
```

## Procedure

1. Run `doctor`. If any check fails, read its message and fix it. A missing `msmtp` must be installed by the user (`sudo pacman -S msmtp` or `sudo apt install msmtp`); the agent cannot install it.
2. To send, pass the absolute path to the file. Quote paths with spaces or accents:
   `~/.local/bin/kindle-mail send "/home/mmc/Downloads/Economia+Numa+unica+lição.pdf"`
3. Report the output line (`Sent ... to ...`). Kindle delivery usually takes a few minutes.
4. Never print or echo the app password. Never write it to a file.

## Rules

- The sending Gmail address must be on the user's Amazon "Approved Personal Document E-mail List", or Kindle rejects the mail.
- Run `setup --new-password` only when the user asks to change the Gmail app password, and ask them for it through the hidden prompt. Do not pass passwords as arguments.
- The send command only works with the Kindle address saved in `~/.config/kindle-mail/settings.json`, unless `--to` is given.
