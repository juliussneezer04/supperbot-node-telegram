# commands
openjio - Open a supper jio
closejio - Close the jio
about - Find out more
help - Detailed instructions and troubleshooting

# birthday easter egg

The birthday easter egg is a feature where, if a telegram command containing a specific phrase (eg "happybd", "happybirthday", "shanhousebesthouse") is repeated 10 times, the bot will repeat it once. This count is reset after 24 hours of no mentions.

## privacy mode disabled is required for birthday easter egg

Supperbot only captures messages starting with a `/`

### How telegram handles bots with privacy mode enabled

When privacy mode is enabled, a bot will only be able to receive command messages after it is tagged. When another bot command is activated, the bot will no longer be able to receive command messages. For example, if haze_bot is issued a command, supperbot will not be able to receive the message `/openjio` even though it is a supperbot command. Supperbot can then only receive commands again when it is tagged, for example with a command `/openjio@supper_bot`.

Hence, the birthday easter egg feature will not work with privacy mode enabled.

## Testing with MochaJS

### Setup

This guide is meant for the WebStorm IDE by JetBrains. For other IDEs please refer to the respective setup guides.

(Alternatively, refer to [Mocha - the fun, simple, flexible JavaScript test framework (mochajs.org)](https://mochajs.org/#installation))

1. Run `npm i --g --save-dev mocha` and then `npm i --save-dev nyc` in your terminal to install Mocha
and NYC Mocha (Tool used with Mocha to show Test COde Coverage).
2. Navigate to `Run > Edit Configurations` from the menu bar to open the `Run/Debug Configurations` window.
3. Click on the `+` icon on the top left and select Mocha. (Don't see Mocha as an Option? You'll need to add the Node.js Plug-in to WebStorm first)
4. Name the configuration any relevant name (e.g. `HelpersTestingSuite`).
5. Select the Node.js interpreter used by your project (The default interpreter should be the one used by the Project - this is sufficient).
6. Ensure that the Working directory is the Project directory, and the Mocha package refers to the installed Mocha package.
7. User interface should be set to `bdd`.
8. For the Test directory, choose the folder containing test suites (e.g. `test/helpersTest`), and select the `All in directory` option above it.
9. Click ok to complete Configuration setup.
10. Test cases written in the Mocha framework within the test directory can now be run by running the configuration!
11. Run `npm test` command in terminal, if it shows `Error: No test cases`, you're all set.

Note: Documentation for testing library can be found here:

https://nodejs.org/api/assert.html

https://mochajs.org/ (only BDD-style functions)

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
