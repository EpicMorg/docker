#!/usr/bin/env python3
"""
EpicMorg Telegram quotes bot.

Requires python-telegram-bot >= 22 (async API), Python >= 3.10.
"""

from __future__ import annotations

import json
import logging
import os
import random
import re
import sys
from pathlib import Path
from typing import Any, Callable
from uuid import uuid4

from telegram import (
    BotCommand,
    InlineQueryResultArticle,
    InputTextMessageContent,
    Update,
)
from telegram.constants import ChatType
from telegram.error import TelegramError
from telegram.ext import (
    Application,
    ApplicationBuilder,
    CommandHandler,
    ContextTypes,
    InlineQueryHandler,
)

# --------------------------------------------------------------------------- #
# Configuration
# --------------------------------------------------------------------------- #

APP_DIR = Path(__file__).resolve().parent
DATA_DIR = Path(os.getenv("BOT_DATA_DIR", APP_DIR))

QUOTES_FILE = Path(os.getenv("BOT_QUOTES_FILE", DATA_DIR / "quotes.txt"))
TRANSLATIONS_FILE = Path(os.getenv("BOT_TRANSLATIONS_FILE", DATA_DIR / "translations.json"))
_token_file_env = (os.getenv("TELEGRAM_BOT_TOKEN_FILE") or "").strip()
TOKEN_FILE_EXPLICIT = bool(_token_file_env)
TOKEN_FILE = Path(_token_file_env) if _token_file_env else DATA_DIR / "token.txt"

BOT_VERSION = os.getenv("BOT_VERSION", "").strip()
LOG_LEVEL = os.getenv("BOT_LOG_LEVEL", "INFO").upper()

# Empty (default) -> plain text, quotes are sent verbatim.
# Set to HTML / MarkdownV2 if you intentionally put markup into quotes.txt.
PARSE_MODE: str | None = os.getenv("BOT_PARSE_MODE", "").strip() or None

# Telegram hard limit for inline answers is 50.
INLINE_RESULTS = max(1, min(50, int(os.getenv("BOT_INLINE_RESULTS", "20"))))

# Reply to a bare /say in groups instead of requiring an explicit @mention.
SAY_IN_GROUPS_WITHOUT_MENTION = os.getenv("BOT_SAY_IN_GROUPS", "").lower() in {"1", "true", "yes"}

COMMANDS = ("start", "say", "help", "version")

DEFAULT_TRANSLATIONS: dict[str, Any] = {
    "start_message": "Simple start message here.",
    "help_message": "Simple help message here.",
    "version_message": "unknown",
    "quote_button_text": "Quote",
    "empty_message": "Quote list is empty.",
    "commands": {
        "start": {"description": "Start"},
        "say": {"description": "Random quote"},
        "help": {"description": "Help"},
        "version": {"description": "Version"},
    },
}

logger = logging.getLogger("quotes-bot")


# --------------------------------------------------------------------------- #
# Hot-reloadable data files
# --------------------------------------------------------------------------- #


class ReloadableFile:
    """Lazily re-reads a file when its mtime changes; keeps last good value on error."""

    def __init__(self, path: Path, loader: Callable[[Path], Any], fallback: Any) -> None:
        self._path = path
        self._loader = loader
        self._data = fallback
        self._fallback = fallback
        self._mtime: float | None = None
        self._loaded_once = False

    @property
    def path(self) -> Path:
        return self._path

    @property
    def data(self) -> Any:
        try:
            mtime = self._path.stat().st_mtime
        except OSError as exc:
            if not self._loaded_once:
                self._loaded_once = True
                logger.error("Cannot stat %s: %s — using defaults", self._path, exc)
            return self._data

        if self._loaded_once and mtime == self._mtime:
            return self._data

        try:
            self._data = self._loader(self._path)
            self._mtime = mtime
            logger.info("Loaded %s", self._path)
        except Exception as exc:  # noqa: BLE001 - never die because of a bad data file
            logger.error("Failed to load %s: %s — keeping previous data", self._path, exc)
            self._mtime = mtime
        finally:
            self._loaded_once = True

        return self._data


def _load_quotes(path: Path) -> list[str]:
    with path.open("r", encoding="utf-8") as fh:
        return [line.strip() for line in fh if line.strip()]


def _deep_merge(base: dict[str, Any], override: dict[str, Any]) -> dict[str, Any]:
    result = dict(base)
    for key, value in override.items():
        if isinstance(value, dict) and isinstance(result.get(key), dict):
            result[key] = _deep_merge(result[key], value)
        else:
            result[key] = value
    return result


def _load_translations(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as fh:
        return _deep_merge(DEFAULT_TRANSLATIONS, json.load(fh))


quotes = ReloadableFile(QUOTES_FILE, _load_quotes, [])
translations = ReloadableFile(TRANSLATIONS_FILE, _load_translations, DEFAULT_TRANSLATIONS)


def tr(key: str) -> str:
    return str(translations.data.get(key, DEFAULT_TRANSLATIONS.get(key, key)))


# --------------------------------------------------------------------------- #
# Token
# --------------------------------------------------------------------------- #


TOKEN_RE = re.compile(r"^\d+:[A-Za-z0-9_-]{30,}$")


def _accept_token(token: str, source: str) -> str:
    """Log where the token came from. Never logs the secret itself."""
    if TOKEN_RE.match(token):
        logger.info("Token loaded from %s (bot id %s)", source, token.split(":", 1)[0])
    else:
        logger.warning(
            "Token from %s does not look like a Telegram bot token ('<bot_id>:<secret>') — "
            "check for a stray 'KEY=' prefix, quotes or extra lines",
            source,
        )
    return token


def get_token() -> str:
    """
    Resolution order:
      1. TELEGRAM_BOT_TOKEN_FILE — explicit path / docker secret, wins over the env var
      2. TELEGRAM_BOT_TOKEN
      3. token.txt in the data dir (legacy, only if it exists)

    An explicitly configured token file that cannot be read is fatal: silently
    falling back to a different token means running as the wrong bot.
    """
    env_token = (os.getenv("TELEGRAM_BOT_TOKEN") or "").strip()

    if TOKEN_FILE_EXPLICIT:
        try:
            file_token = TOKEN_FILE.read_text(encoding="utf-8").strip()
        except OSError as exc:
            logger.error("TELEGRAM_BOT_TOKEN_FILE=%s is not readable: %s", TOKEN_FILE, exc)
            sys.exit(1)

        if not file_token:
            logger.error("TELEGRAM_BOT_TOKEN_FILE=%s is empty", TOKEN_FILE)
            sys.exit(1)

        if env_token and env_token != file_token:
            logger.warning(
                "Both TELEGRAM_BOT_TOKEN and TELEGRAM_BOT_TOKEN_FILE are set and differ — "
                "the file wins"
            )
        return _accept_token(file_token, f"file {TOKEN_FILE}")

    if env_token:
        return _accept_token(env_token, "TELEGRAM_BOT_TOKEN")

    try:
        legacy_token = TOKEN_FILE.read_text(encoding="utf-8").strip()
    except OSError:
        legacy_token = ""

    if legacy_token:
        return _accept_token(legacy_token, f"file {TOKEN_FILE}")

    logger.error(
        "Token not found. Set TELEGRAM_BOT_TOKEN, or point TELEGRAM_BOT_TOKEN_FILE "
        "at a readable file, or create %s.",
        TOKEN_FILE,
    )
    sys.exit(1)


# --------------------------------------------------------------------------- #
# Handlers
# --------------------------------------------------------------------------- #


async def start(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if update.effective_message:
        await update.effective_message.reply_text(tr("start_message"))


async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if update.effective_message:
        await update.effective_message.reply_text(tr("help_message"))


async def version_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if update.effective_message:
        await update.effective_message.reply_text(BOT_VERSION or tr("version_message"))


async def say(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    message = update.effective_message
    if message is None:
        return

    if message.chat.type != ChatType.PRIVATE and not SAY_IN_GROUPS_WITHOUT_MENTION:
        text = message.text or message.caption or ""
        username = context.bot.username
        if not username or f"@{username}" not in text:
            return

    pool = quotes.data
    if not pool:
        logger.warning("No quotes loaded from %s", quotes.path)
        await message.reply_text(tr("empty_message"))
        return

    await message.reply_text(random.choice(pool), parse_mode=PARSE_MODE)


async def inline_query(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    query = update.inline_query
    if query is None:
        return

    needle = (query.query or "").strip().casefold()
    pool = quotes.data
    if needle:
        pool = [quote for quote in pool if needle in quote.casefold()]

    results = [
        InlineQueryResultArticle(
            id=str(uuid4()),
            title=quote[:64],
            description=quote[64:184] or None,
            input_message_content=InputTextMessageContent(
                message_text=quote,
                parse_mode=PARSE_MODE,
            ),
        )
        for quote in random.sample(pool, min(INLINE_RESULTS, len(pool)))
    ]

    try:
        # cache_time=0 + is_personal: otherwise Telegram caches the first random
        # batch for 300s and the user keeps seeing the same quotes.
        await query.answer(results, cache_time=0, is_personal=True)
    except TelegramError as exc:
        logger.error("Error answering inline query: %s", exc)


async def on_error(update: object, context: ContextTypes.DEFAULT_TYPE) -> None:
    logger.error("Unhandled exception while processing update", exc_info=context.error)


# --------------------------------------------------------------------------- #
# Lifecycle
# --------------------------------------------------------------------------- #


async def post_init(application: Application) -> None:
    descriptions = translations.data.get("commands", {})
    await application.bot.set_my_commands(
        [
            BotCommand(
                name,
                str(
                    descriptions.get(name, {}).get(
                        "description", DEFAULT_TRANSLATIONS["commands"][name]["description"]
                    )
                ),
            )
            for name in COMMANDS
        ]
    )
    logger.info(
        "Started as @%s | quotes: %d from %s",
        application.bot.username,
        len(quotes.data),
        quotes.path,
    )


def main() -> None:
    logging.basicConfig(
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        level=getattr(logging, LOG_LEVEL, logging.INFO),
    )
    # httpx logs every getUpdates poll at INFO — that is one line per second.
    logging.getLogger("httpx").setLevel(logging.WARNING)

    token = get_token()

    # Warm up the data files so config errors surface before polling starts.
    translations.data
    if not quotes.data:
        logger.warning("Quote list at %s is empty or unreadable", quotes.path)

    application = (
        ApplicationBuilder()
        .token(token)
        .concurrent_updates(True)
        .post_init(post_init)
        .build()
    )

    application.add_handler(CommandHandler("start", start))
    application.add_handler(CommandHandler("say", say))
    application.add_handler(CommandHandler("help", help_command))
    application.add_handler(CommandHandler("version", version_command))
    application.add_handler(InlineQueryHandler(inline_query))
    application.add_error_handler(on_error)

    application.run_polling(allowed_updates=Update.ALL_TYPES)


if __name__ == "__main__":
    main()
