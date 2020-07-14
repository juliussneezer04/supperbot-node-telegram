const util = require('util');
const cloneextend = require('cloneextend');
const sprintf = require("sprintf-js").sprintf;
const queries = require('../db/queries');
const menus = require('../config').menus;
const commands = require('../config').commands;
const {InlineKeyboard} = require('node-telegram-keyboard-wrapper');
const messenger = require('../messenger');

const OPEN_JIO_COMMAND_ID = commands.indexOf('openjio');
const CANCEL_COMMAND_ID = commands.indexOf('cancel');
const CREATION_SUCCESS_TEMPLATE = '%s created a jio for %s. Click on /additem to add your orders to the jio.'
const CREATION_SUCCESS_TIME_TEMPLATE = ', with duration %s minutes.';
const CREATION_FAILURE_TEMPLATE = 'Sorry, there was an unknown error in opening the jio'


module.exports.init = async function (msg) {
    //can receive the open jio command in a group, but the bot messages the user directly to ask for restaurant/duration
    if (await queries.hasJio(msg.chat.id)) {
        messenger.send(msg.chat.id, 'There is already a jio open in this chat!');
    } else if (msg.chat.id === msg.from.id) {
        messenger.send(msg.chat.id, 'You should open a jio in a group instead!');
    } else {
        //send options to user through direct message
        const ik = new InlineKeyboard();
        for (let i = 0; i < menus.length; i++) {
            let data = {t: OPEN_JIO_COMMAND_ID, chat_id: msg.chat.id, m: i}
            ik.addRow({text: menus[i], callback_data: JSON.stringify(data)})
        }
        ik.addRow({text: 'Cancel', callback_data: JSON.stringify({t: CANCEL_COMMAND_ID})});
        const text = 'What will you like for supper?';
        messenger.send(msg.from.id, text, ik.build(), msg.chat.id);
        //update group to ask user to check their direct messages
        messenger.send(msg.chat.id, sprintf('Alright %s, I\'ll message you directly for more details', msg.from.first_name));
        //TODO: store this message id, update it when openjio success or cancelled
    }
}


module.exports.callback = async function (query) {
    return commit(query);
}

const embed = function (data, x) {
    return cloneextend.cloneextend(data, x);
}

const commit = async function (query) {
    try {
        const data = JSON.parse(query.data);
        if (!data.duration) {
            data.duration = -1;
        }
        let params = {
            chat_id: data['chat_id'],
            creator_id: query.from.id,
            creator_name: query.from.first_name,
            duration: data['duration'],//TODO: update database, duration no longer used
            menu: data['m'],
        }

        await queries.openJio(params);

        notifyOpenjioSuccess(query);

    } catch (e) {
        console.log(e);
        notifyOpenjioFailure(e, query);
    }
}

const notifyOpenjioSuccess = async function (query) {
    let data = JSON.parse(query.data);
    // send success message to group
    let text = util.format(CREATION_SUCCESS_TEMPLATE, query.from.first_name,
        menus[data['m']]);
    const ik = new InlineKeyboard();
    ik.addRow({text: 'add item', callback_data: '{"cmd": "additem"}'});
    ik.addRow({text: 'remove item', callback_data: '{"cmd": "removeitem"}'});
    ik.addRow({text: 'view my orders', callback_data: '{"cmd": "viewmyorders"}'});
    ik.addRow({text: 'close jio', callback_data: '{"cmd": "closejio"}'});
    await messenger.send(data['chat_id'], text, ik.build());
    //TODO: store message ID for live menu update

    // edit the direct message to user
    let text2 = 'Jio created successfully!';
    messenger.edit(
        query.message.chat.id,
        query.message.message_id,
        null,
        text2,
        null);
}

const notifyOpenjioFailure = async function (err, query) {
    messenger.edit(
        query.message.chat.id,
        query.message.message_id,
        null,
        CREATION_FAILURE_TEMPLATE,
        null);
}
