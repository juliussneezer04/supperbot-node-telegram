// var util = require('util');
var cloneextend = require('cloneextend');

var queries = require('../db/queries');
var menus = require('../config').menus;
var commands = require('../config').commands;
const {InlineKeyboard} = require('node-telegram-keyboard-wrapper');

const OPEN_JIO_COMMAND_ID = commands.indexOf('openjio');
const CANCEL_COMMAND_ID = commands.indexOf('cancel');
const CREATION_SUCCESS_TEMPLATE = '%s created a jio for %s'
const CREATION_SUCCESS_TIME_TEMPLATE = ', with duration %s minutes.';
const CREATION_FAILURE_TEMPLATE = 'Jio already exists in the chat!'


module.exports.init = function (msg, bot) {
    //can receive the open jio command in a group, but the bot messages the user directly
    const ik = new InlineKeyboard();
    for (let i = 0; i < menus.length; i++) {
        let data = {t: OPEN_JIO_COMMAND_ID, chat_id: msg.chat.id, m: i}
        ik.addRow({text: menus[i], callback_data: JSON.stringify(data)})
    }
    ik.addRow({text: 'Cancel', callback_data: JSON.stringify({t: CANCEL_COMMAND_ID})});
    let r = bot.sendMessage(msg.from.id, 'What will you like for supper?', ik.build());
    "";
}


module.exports.callback = async function (query, bot) {
    let data = JSON.parse(query.data);
    if (data.duration) {
        return commit(query, bot);
    }
    const ik = new InlineKeyboard();
    const duration_options = [
        ['15 min', 15],
        ['30 min', 30],
        ['60 min', 60],
        ['90 min', 90],
        ['unlimited', -1]
    ];
    for (const d of duration_options) {
        ik.addRow({text: d[0], callback_data: JSON.stringify(embed(data, {duration: d[1]}))});
    }
    ik.addRow({text: 'Cancel', callback_data: JSON.stringify({t: CANCEL_COMMAND_ID})});
    const text = 'How long will you like the jio to be open for?';
    await bot.editMessageText(text, {chat_id: query.message.chat.id, message_id: query.message.message_id})
    await bot.editMessageReplyMarkup(ik.build().reply_markup, {
        chat_id: query.message.chat.id,
        message_id: query.message.message_id
    });
}

var embed = function (data, x) {
    return cloneextend.cloneextend(data, x);
}

var commit = async function (query, bot) {
    try {
        let data = JSON.parse(query.data);
        let params = {
            chat_id: data['chat_id'],
            creator_id: query.from.id,
            creator_name: query.from.first_name,
            duration: data['duration'],
            menu: data['m'],
        }

        await queries.openJio(params);

        await notifyOpenjioSuccess(query, bot);

    } catch (err) {
        await notifyOpenjioFailure(err, query, bot);
    }
}

var notifyOpenjioSuccess = async function (query, bot) {
    let data = JSON.parse(query.data);
    // send success message to group
    let text = util.format(CREATION_SUCCESS_TEMPLATE, query.from.first_name,
        menus[data['m']]);
    if (data['duration'] !== -1) { // if time is not unlimited
        text += util.format(CREATION_SUCCESS_TIME_TEMPLATE, data['duration']);
    }
    msg.send(data['chat_id'], text, null);
    bot.sendMessage(data['chat_id'], text, null);
    // send success message to user
    let text2 = 'Jio created!';
    await bot.editMessageText(text2, {chat_id: query.message.chat.id, message_id: query.message.message_id})
}

var notifyOpenjioFailure = async function (err, query, bot) {
    console.log(err);
    await bot.editMessageText(CREATION_FAILURE_TEMPLATE, {
        chat_id: query.message.chat.id,
        message_id: query.message.message_id
    })
}
