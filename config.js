require('dotenv').config()
module.exports.token = process.env.BOT_TOKEN
module.exports.server_url = process.env.SERVER_URL //no uses?
module.exports.api_url = process.env.API_URL + module.exports.token + '/'
// module.exports.secret_url = process.env.SERVER_URL+process.env.BOT_TOKEN
module.exports.bot_name = process.env.BOT_NAME
module.exports.debug = JSON.parse(process.env.DEBUG)
module.exports.stringsToMatch = JSON.parse(process.env.BIRTHDAY_STRINGS)

//testing for heroku env variables
// console.log("token: ", module.exports.token);
// console.log("server url: ", module.exports.server_url);
// console.log("api_url: ", module.exports.api_url);
// console.log("bot_name: ", module.exports.bot_name);

module.exports.db_config = {
    user: process.env.DB_USER, //env var: PGUSER
    database: process.env.DB_DATABASE, //env var: PGDATABASE
    password: process.env.DB_PASSWORD, //env var: PGPASSWORD
    host: process.env.DB_HOST, // Server hosting the postgres database
    port: 5432, //env var: PGPORT
    max: 10, // max number of clients in the pool
    idleTimeoutMillis: 30000, // how long a client is allowed to remain idle before being closed
};

module.exports.menus = [
    'Al Amaans',
    'Koi'
];

module.exports.commands = [
    'cancel',
    'openjio',
    'additem',
    'removeitem',
    'addmod',
    'closejioconfirm'
]

module.exports.help = "We currently only allow one concurrent jio per chat.\n\n" +
    "If you are unable to access the jio message, you can use /closejio to manually close the jio.\n\n" +
    "Only the jio creator or group admins can close a jio.\n\n" +
    "Some options become invalidated after 48 hours.";

module.exports.about = "Developed by @nicktohzyu and @iamjamestan, building on the original supperbot by Lester. " +
    "Submit inquiries or bug reports at https://github.com/nicktohzyu/supperbot-node-telegram/issues"; //insert github link

module.exports.start = "Welcome! You can now add items to jios.\n\n" +
    "Open a jio in a group chat with /openjio, use /help for troubleshooting, and read about me in /about."

module.exports.superusers = [653601805] //array of user id
