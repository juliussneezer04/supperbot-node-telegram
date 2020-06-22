const TelegramBot = require('node-telegram-bot-api');
const openjio = require('./handlers/openjio');
const additem = require('./handlers/additem');
const removeitem = require("./handlers/removeitem");
const closejio = require('./handlers/closejio');
const vieworder = require("./handlers/vieworder");
const viewmyorders = require("./handlers/viewmyorders");

const commands = require('./config').commands;
const config = require('./config');
const messenger = require('./messenger');
const token = config.token;

let bot;
if (process.env.NODE_ENV === 'production') {
    bot = new TelegramBot(token);
    bot.setWebHook(process.env.HEROKU_URL + bot.token);
} else {
    bot = new TelegramBot(token, {polling: true});
}

messenger.init(bot);

bot.on('message', (msg) => {
    if (msg.reply_to_message) {
        additem.reply(msg, bot);
        return;
    }
    let command;
    if (msg.text != null && msg.text.includes('@')) {
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
        // case '/about':
        //     about.init(msg);
        //     break;
        default:
            break;//TODO: invalid command message
    }
    // send a message to the chat acknowledging receipt of their message
    // bot.sendMessage(chatId, 'Received your message');
});

bot.on('callback_query', (query) => {

    let data = JSON.parse(query.data);
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
        default:
            break;
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

console.log("bot running");