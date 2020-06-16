const TelegramBot = require('node-telegram-bot-api');
const openjio = require('./handlers/openjio');
const closejio = require('./handlers/closejio');
const commands = require('./config').commands;
const config = require('./config');

const token = process.env.BOT_TOKEN;
let bot;

if (process.env.NODE_ENV === 'production') {
    bot = new TelegramBot(token);
    bot.setWebHook(process.env.HEROKU_URL + bot.token);
} else {
    bot = new TelegramBot(token, {polling: true});
}

bot.on('message', (msg) => {
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
            openjio.init(msg, bot);
            break;
        case '/closejio':
            closejio.init(msg, bot);
            break;
        // case '/additem':
        //     additem.init(msg, bot);
        //     break;
        // case '/removeitem':
        //     removeitem.init(msg, bot);
        //     break;
        // case '/vieworder':
        //     vieworder.init(msg, bot);
        //     break;
        // case '/viewmyorders':
        //     viewmyorders.init(msg, bot);
        // case '/about':
        //     break;
        default:
            break;
    }
    // send a message to the chat acknowledging receipt of their message
    // bot.sendMessage(chatId, 'Received your message');
});

bot.on('callback_query', (query) => {

    let data = JSON.parse(query.data);
    switch (commands[data.t]) {
        case 'cancel':
            cancelCallback(query, bot);
            break;
        case 'openjio':
            openjio.callback(query, bot);
            break;
        //     case 'additem':
        //         additem.callback(query, bot);
        //         break;
        //     case 'removeitem':
        //         removeitem.callback(query, bot);
        //         break;
        //     case 'addmod':
        //         additem.callback_mod(query, bot);
        default:
            break;
    }
})

function cancelCallback(query, bot) {
    text = 'Your request has been cancelled!';
    bot.editMessageText( text, {chat_id: query.message.chat.id,message_id: query.message.message_id})
}

console.log("bot running");