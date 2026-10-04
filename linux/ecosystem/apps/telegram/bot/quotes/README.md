<!-- hub-description: Telegram bot that replies with random quotes from a text file (python-telegram-bot) -->
# `epicmorg/telegram`

Small Telegram bots. Currently one: **`bot-quotes`** — answers `/say` (and inline queries) with a
random quote from `quotes.txt`. Python 3 from `epicmorg/debian:trixie`,
[python-telegram-bot](https://python-telegram-bot.org/) 22.

## What's inside

* the bot in `/usr/local/share/epicmorg/telegram/bot/quotes`: `bot.py`, a sample `quotes.txt`
  and `translations.json` ([sources](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/apps/telegram/bot/quotes/bot))
* commands: `/start`, `/say`, `/help`, `/version`; all texts and command descriptions come from
  `translations.json`
* `quotes.txt` and `translations.json` are re-read when they change on disk — no restart needed

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `bot-quotes` | [`.`](./Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/telegram:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

1. Copy and edit `quotes.txt` (one quote per line) and `translations.json`.
2. Run with your bot token:

```yaml
services:
  quotes:
    image: epicmorg/telegram:bot-quotes
    restart: unless-stopped
    environment:
      TELEGRAM_BOT_TOKEN: "<bot_id>:<secret>"
    volumes:
      - ./quotes.txt:/usr/local/share/epicmorg/telegram/bot/quotes/quotes.txt:ro
      - ./translations.json:/usr/local/share/epicmorg/telegram/bot/quotes/translations.json:ro
```

| Variable | Default | Meaning |
| --- | --- | --- |
| `TELEGRAM_BOT_TOKEN` | — | bot token |
| `TELEGRAM_BOT_TOKEN_FILE` | — | path to a file with the token (e.g. a Docker secret); wins over `TELEGRAM_BOT_TOKEN`. Without both, `token.txt` in the data dir is used if present |
| `BOT_DATA_DIR` | the bot directory | where `quotes.txt`, `translations.json`, `token.txt` are looked up |
| `BOT_QUOTES_FILE` / `BOT_TRANSLATIONS_FILE` | `<data dir>/…` | explicit file paths |
| `BOT_PARSE_MODE` | plain text | `HTML` or `MarkdownV2` if quotes contain markup |
| `BOT_INLINE_RESULTS` | `20` | inline answers per query (1–50) |
| `BOT_SAY_IN_GROUPS` | off | `true` — answer a bare `/say` in groups without an @mention |
| `BOT_VERSION` | — | reply to `/version` (otherwise `version_message` from `translations.json`) |
| `BOT_LOG_LEVEL` | `INFO` | log level |

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
