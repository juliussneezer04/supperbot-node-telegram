const TelegramBot = require('node-telegram-bot-api');
const axios = require('axios');
// This file would be created soon

require('dotenv').config();

const token = process.env.BOT_TOKEN;
let bot;

if (process.env.NODE_ENV === 'production') {
    bot = new TelegramBot(token);
    bot.setWebHook(process.env.HEROKU_URL + bot.token);
} else {
    bot = new TelegramBot(token, {polling: true});
}

bot.on('message', (msg) => {
    const chatId = msg.chat.id;

    // send a message to the chat acknowledging receipt of their message
    bot.sendMessage(chatId, 'Received your message');
});

bot.on('callback_query', (msg)=>{
    
})