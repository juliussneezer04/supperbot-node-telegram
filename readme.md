# birthday easter egg

The birthday easter egg is a feature where, if a telegram command containing a specific phrase (eg "happybd", "happybirthday", "shanhousebesthouse") is repeated 10 times, the bot will repeat it once. This count is reset after 24 hours of no mentions.

## privacy mode disabled is required for birthday easter egg

Supperbot only captures messages starting with a `/`

### How telegram handles bots with privacy mode enabled

When privacy mode is enabled, a bot will only be able to receive command messages after it is tagged. When another bot command is activated, the bot will no longer be able to receive command messages. For example, if haze_bot is issued a command, supperbot will not be able to receive the message `/openjio` even though it is a supperbot command. Supperbot can then only receive commands again when it is tagged, for example with a command `/openjio@supper_bot`.

Hence, the birthday easter egg feature will not work with privacy mode enabled.

# .env
API_URL=
BIRTHDAY_STRINGS=
BOT_NAME=
BOT_TOKEN=
DATABASE_URL=
DB_DATABASE=
DB_HOST=
DB_PASSWORD=
DB_USER=
DEBUG=
## for deploy
HEROKU_URL=
SERVER_URL=
