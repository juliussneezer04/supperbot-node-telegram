# Guide for new devs
1. Create jetbrains student account if you have not
2. Install jetbrains toolbox
  - It handles updating and installing the various IDEs for you
3. Install webstorm
4. Install git
  - I recommend github desktop for its simple interface
5. Install postgreSQL
  - The password you set doesn’t have to be secure, but do not lose it
  - The installation should also come with pgAdmin, a GUI that allows you to visually edit and see data
6. Load database capture (menu and tables) to local postgres instance
  - Use DB backups in the repo (both dump and sql file should work)
  - Process to restore backup:
    - Create new database and name it
    - Right click on that database and click ‘restore’
    - Select ‘DB.backup’ file 
    - Menudata, jio data etc should be reflected in the schemas of the database
    - You may have to use command line and manually enter your password (my pgadmin seems to incorrectly use the –no-password option
  - Can use either command line or pgadmin
7. Create new telegram bot handle for your personal testing purposes
  - Go to ‘botfather’ bot on telegram
  - Create new bot with name and handle like “nic_supperbot_dev_bot” (the name doesn’t matter)
8. Create .env file in your repository
  - Add the bot token
  - Add postgres credentials (you can use postgres as the DB_USER if you hadn’t created user1)
  - Leave SERVER_URL and DATABASE_URL blank for local hosting
  - Set debug to true
9. Run index.js in WebStorm
10. Create a group with your bot to chat with it 
  - Remember that jios must be opened in a group chat
  - To test, simply create a group with you and your bot (or other people helping to test)


# Commands
openjio - Open a supper jio  
closejio - Close the jio  
about - Find out more  
help - Detailed instructions and troubleshooting  

# Birthday easter egg

The birthday easter egg is a feature where, if a telegram command containing a specific phrase (eg "happybd", "happybirthday", "shanhousebesthouse") is repeated 10 times, the bot will repeat it once. This count is reset after 24 hours of no mentions.

## Privacy mode disabled is required for birthday easter egg

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
