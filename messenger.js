const bot_name = require('./config').bot_name;
const {InlineKeyboard} = require('node-telegram-keyboard-wrapper');
let bot;

module.exports.init = function (b) {
    bot = b;
}

const sendStartMe = function (chat_id) {
    //no await, because if it does not work we do not send any more messages
    // send 'Start chat!' inline message
    try {
        bot.sendMessage(
            chat_id,
            'Hi there, please start a chat with me first!',
            new InlineKeyboard().addRow({
                text: 'Start chat!',
                url: 'https://telegram.me/' + bot_name,
            }).build());
    } catch (e) {
        console.log(e);
    }
}

module.exports.send = async function (chat_id, text, reply_markup, startme_chat) {
    try {
        await bot.sendMessage(chat_id, text, reply_markup);
    } catch (e) { //TODO: better catching
        if (startme_chat != null) {
            sendStartMe(startme_chat);
        }
    }
}

module.exports.edit = async function (chat_id, message_id, inline_message_id, text, reply_markup) {
    try {
        // await bot.editMessageReplyMarkup(reply_markup,
        //     {chat_id: chat_id, message_id: message_id});
        await bot.editMessageText(text,
            {chat_id: chat_id, message_id: message_id, reply_markup: reply_markup});
    } catch (e) {
        console.log(e);
    }
}