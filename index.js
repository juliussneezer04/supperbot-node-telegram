const TelegramBot = require('node-telegram-bot-api');
const schedule = require('node-schedule');
const openjio = require('./handlers/openjio');
const additem = require('./handlers/additem');
const removeitem = require("./handlers/removeitem");
const closejio = require('./handlers/closejio');
const vieworder = require("./handlers/vieworder");
const viewmyorders = require("./handlers/viewmyorders");
const birthday = require("./handlers/birthday").birthday;
const queries = require('./db/queries');
const config = require('./config');
const messenger = require('./messenger');
const {token, commands, debug} = config;

let bot;
if (process.env.NODE_ENV === 'production') {
    bot = new TelegramBot(token, {webHook: {port: process.env.PORT}});
    bot.setWebHook(process.env.HEROKU_URL + bot.token);
} else {
    bot = new TelegramBot(token, {polling: true});
}

messenger.initBot(bot);
closejio.initbot(bot);
additem.initbot(bot);
openjio.initbot(bot);
queries.initbot(bot);

bot.on('message', (msg) => {
    if (debug) {
        let message = "received message with text \"" + msg.text + "\" from \"" + msg.from.username + "\""
        if (msg.chat.hasOwnProperty("title")) {
            message += " in chat \"" + msg.chat.title  + "\"";
        } else {
            message += " via direct message"
        }
        console.log(message);
    }
    let command;
    if (msg.text == null) {
        console.log("error: message text from " + msg.from.id + "is null");
        return;
    }
    if (msg.text.includes('@')) {
        let tokens = msg.text.split('@');
        if (tokens[1] !== config.bot_name) {
            return;
        }
        command = tokens[0];
    } else {
        command = msg.text;
    }
    switch (command) {
        case '/openjio':
            openjio.init(msg);
            break;
        case '/closejio':
            closejio.init(msg);
            break;
        case '/additem':
            additem.init(msg);
            break;
        case '/removeitem':
            removeitem.init(msg);
            break;
        case '/vieworder':
            vieworder.init(msg);
            break;
        case '/viewmyorders':
            viewmyorders.init(msg);
            break;
        case '/about':
            messenger.send(msg.chat.id, config.about);
            break;
        case '/help':
            messenger.send(msg.chat.id, config.help);
            break;
        case '/start':
            messenger.send(msg.chat.id, config.start);
            break;
        default:
            birthday(msg);
            break;
    }
});

bot.on('callback_query', (query) => {

    let data = JSON.parse(query.data);
    if (data.hasOwnProperty("cmd")) {
        query.chat = query.message.chat; //TODO: clean this hack
        switch (data.cmd) {
            case 'additem':
                additem.init(query)
                break;
            case 'removeitem':
                removeitem.init(query);
                break;
            case 'viewmyorders':
                viewmyorders.init(query);
                break;
            case 'closejio':
                closejio.init(query);
                break;
            default:
                break;
        }
    } else if (data.hasOwnProperty("t")) {
        switch (commands[data.t]) {
            case 'cancel':
                cancelCallback(query);
                break;
            case 'openjio':
                openjio.callback(query);
                break;
            case 'additem':
                additem.callback(query);
                break;
            case 'removeitem':
                removeitem.callback(query);
                break;
            case 'addmod':
                additem.callback_mod(query);
                break;
            case 'closejioconfirm':
                closejio.callback(query);
                break;
            default:
                break;
        }
    }
})

function cancelCallback(query) {
    messenger.edit(
        query.message.chat.id,
        query.message.message_id,
        null,
        'Your request has been cancelled!',
        null);
}
// schedule.scheduleJob('0 6 * * *', () => {
//     queries.clearOldEntries('miscellaneous', 'helper');
//     queries.clearOldEntries('miscellaneous', 'cache');
// });
console.log("bot running");