const TelegramBot = require('node-telegram-bot-api');
const openjio = require('./handlers/openjio');
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
    if(msg.text!= null && msg.text.includes('@')){
        let tokens = msg.text.split('@');
        if (tokens[1] !== config.bot_name){
            return;
        }
        command = tokens[0];
    } else{
        command = msg.text;
    }
    switch (command) {
        case '/openjio':
            openjio.init(msg, bot);
            break;
        // case '/closejio':
        //     closejio.init(req, res, next);
        //     break;
        // case '/additem':
        //     additem.init(req, res, next);
        //     break;
        // case '/removeitem':
        //     removeitem.init(req, res, next);
        //     break;
        // case '/vieworder':
        //     vieworder.init(req, res, next);
        //     break;
        // case '/viewmyorders':
        //     viewmyorders.init(req, res, next);
        // case '/about':
        //     break;
        default:
            break;
    }
    // send a message to the chat acknowledging receipt of their message
    // bot.sendMessage(chatId, 'Received your message');
});

bot.on('callback_query', (query)=>{

    let data = JSON.parse(query.data);
    switch (data.t) {
    //     case 'cancel':
    //         cancelCallback(req, res, next);
    //         break;
        case commands.indexOf('openjio'):
            openjio.callback(query, bot);
            break;
    //     case 'additem':
    //         additem.callback(req, res, next);
    //         break;
    //     case 'removeitem':
    //         removeitem.callback(req, res, next);
    //         break;
    //     case 'addmod':
    //         additem.callback_mod(req, res, next);
        default:
            break;
    }
})
console.log("bot running");