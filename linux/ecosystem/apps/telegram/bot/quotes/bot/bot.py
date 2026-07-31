import logging
import random
import os
import json
from telegram import Update, BotCommand, InlineQueryResultArticle, InputTextMessageContent
from telegram.ext import Updater, CommandHandler, CallbackContext, InlineQueryHandler
from uuid import uuid4
import html

logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', level=logging.INFO
)
logger = logging.getLogger(__name__)

def get_token():
    token = os.getenv('TELEGRAM_BOT_TOKEN')
    if not token:
        try:
            with open('token.txt', 'r') as file:
                token = file.read().strip()
        except FileNotFoundError:
            logger.error('Token not found. Please set the TELEGRAM_BOT_TOKEN environment variable or create a token.txt file.')
            exit(1)
    return token

def load_translations(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        return json.load(file)

translations = load_translations('translations.json')

def load_quotes(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        quotes = file.readlines()
    return [html.escape(quote.strip()) for quote in quotes]

quotes = load_quotes('quotes.txt')

def start(update: Update, context: CallbackContext) -> None:
    if update.message:
        update.message.reply_text(translations["start_message"], quote=False)

def say(update: Update, context: CallbackContext) -> None:
    message = update.message
    if message.chat.type == 'private': 
        random_quote = random.choice(quotes)
        message.reply_text(random_quote, quote=False)
    elif message.chat.type in ['group', 'supergroup'] and f'@{context.bot.username}' in message.text:
        random_quote = random.choice(quotes)
        message.reply_text(random_quote, quote=False)

def help_command(update: Update, context: CallbackContext) -> None:
    if update.message:
        update.message.reply_text(translations["help_message"], quote=False)

def version_command(update: Update, context: CallbackContext) -> None:
    if update.message:
        update.message.reply_text(translations["version_message"], quote=False)

def inline_query(update: Update, context: CallbackContext) -> None:
    query = update.inline_query.query
    if query == "":
        return

    results = []
    for quote in random.sample(quotes, min(10, len(quotes))):
        result = InlineQueryResultArticle(
            id=str(uuid4()),
            title=quote[:64],
            input_message_content=InputTextMessageContent(message_text=quote)
        )
        results.append(result)
    try:
        update.inline_query.answer(results)
    except Exception as e:
        logger.error(f"Error answering inline query: {e}")

def main() -> None:
    token = get_token()

    updater = Updater(token)

    dispatcher = updater.dispatcher

    dispatcher.add_handler(CommandHandler("start", start))
    dispatcher.add_handler(CommandHandler("say", say))
    dispatcher.add_handler(CommandHandler("help", help_command))
    dispatcher.add_handler(CommandHandler("version", version_command))
    dispatcher.add_handler(InlineQueryHandler(inline_query))

    bot = updater.bot
    bot.set_my_commands([
        BotCommand("start", translations["commands"]["start"]["description"]),
        BotCommand("say", translations["commands"]["say"]["description"]),
        BotCommand("help", translations["commands"]["help"]["description"]),
        BotCommand("version", translations["commands"]["version"]["description"]),
    ])

    
    updater.start_polling()
    updater.idle()

if __name__ == '__main__':
    main()
