const bot_name = require('./config').bot_name;
const {InlineKeyboard} = require('node-telegram-keyboard-wrapper');
let bot;

module.exports.initBot = function (b) {
    bot = b;
}

const sendStartMe = async function (chat_id, startme_chat) {
    //no await, because if it does not work we do not send any more messages
    // send 'Start chat!' inline message
    try {
        const msgData = await queries.getData(chat_id);
        if (msgData !== null) { // startme chat has been sent before, then delete previous
            await bot.deleteMessage(chat_id, msgData.message_id);
            const message_id = await bot.sendMessage(
                startme_chat,
                'Hi there, please start a chat with me first!',//TODO: address user by first_name
                new InlineKeyboard().addRow({
                    text: 'Start chat!',
                    url: 'https://telegram.me/' + bot_name,
                }).build());
            await queries.updateData(chat_id, {message_id: message_id});
        } else { // startme chat has not been sent before
            const message_id = await bot.sendMessage(
                startme_chat,
                'Hi there, please start a chat with me first!',//TODO: address user by first_name
                new InlineKeyboard().addRow({
                    text: 'Start chat!',
                    url: 'https://telegram.me/' + bot_name,
                }).build());
            await queries.storeData(chat_id, {message_id: message_id})
        }
    } catch (e) {
        console.log(e);
    }
}

module.exports.send = async function (chat_id, text, reply_markup = {}, startme_chat) {
    try {
        if (reply_markup == null) {//hack, because default param value doesn't seem to be working
            reply_markup = {};
        }
        return await bot.sendMessage(chat_id, text, reply_markup);
    } catch (e) {
        //TODO: check for startme error
        //blocked: ETELEGRAM: 403 Forbidden: bot was blocked by the user
        console.log(e);
        sendStartMe(chat_id, startme_chat);
    }
}

module.exports.edit = async function (chat_id, message_id, inline_message_id, text, reply_markup) {
    //will remove inline keyboard if reply_markup is null
    try {
        // await bot.editMessageReplyMarkup(reply_markup,
        //     {chat_id: chat_id, message_id: message_id});
        await bot.editMessageText(text,
            {chat_id: chat_id, message_id: message_id, reply_markup: reply_markup});
    } catch (e) {
        console.log(e);
    }
}