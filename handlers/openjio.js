const util = require('util');
const cloneextend = require('cloneextend');
const sprintf = require("sprintf-js").sprintf;
const queries = require('../db/queries');
const menus = require('../config').menus;
const commands = require('../config').commands;
const max_length = require('../config').max_length;
const {InlineKeyboard} = require('node-telegram-keyboard-wrapper');
const messenger = require('../messenger');

const OPEN_JIO_COMMAND_ID = commands.indexOf('openjio');
const CANCEL_COMMAND_ID = commands.indexOf('cancel');
const CREATION_SUCCESS_GROUP_TEMPLATE = '%s created a jio for %s. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.'
const CREATION_SUCCESS_DIRECT_TEMPLATE = 'Jio for %s in chat group \"%s\" created successfully! Reply to this message to add a description to your jio.';
// const CREATION_SUCCESS_TIME_TEMPLATE = ', with duration %s minutes.';
const CREATION_FAILURE_TEMPLATE = 'Sorry, there was an unknown error in opening the jio'
const DESCRIPTION_RECEIVED_RESPONSE = "Received! You can reply to the message again to update your jio description!";
const DESCRIPTION_TOO_LONG_RESPONSE = 'Your description is more than ' + max_length.jio_description.toString() + ' characters, please try again with a shorter description!';

let bot;

module.exports.initbot = function (b) {
    bot = b;
}

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

const embed = function (data, x) {
    return cloneextend.cloneextend(data, x);
}

const notifyOpenjioSuccess = async function (query) {
    let data = JSON.parse(query.data);

    // send success message to group
    let text = util.format(CREATION_SUCCESS_GROUP_TEMPLATE, query.from.first_name,
        menus[data['m']]) + "\n\n";
    const ik = new InlineKeyboard();
    ik.addRow({text: 'add item', callback_data: '{"cmd": "additem"}'});
    ik.addRow({text: 'remove item', callback_data: '{"cmd": "removeitem"}'});
    ik.addRow({text: 'view my orders', callback_data: '{"cmd": "viewmyorders"}'});
    ik.addRow({text: 'close jio', callback_data: '{"cmd": "closejio"}'});
    const ikb = ik.build()
    await queries.storeJioMessageData(data['chat_id'], text, ikb)
    let msg = await messenger.send(data['chat_id'], text + "There are no items in the order currently", ikb);

    //save message id for live update
    let params = {
        chat_id: data['chat_id'],
        message_id: msg.message_id
    }
    await queries.updateOpenJioWithMsgID(params)

    // edit the direct message to user
    const chat = await bot.getChat(data['chat_id']);
    const chatName = chat.title;
    let text2 = util.format(CREATION_SUCCESS_DIRECT_TEMPLATE,
        menus[data['m']], chatName);
    messenger.edit(
        query.message.chat.id,
        query.message.message_id,
        null,
        text2,
        null);

    //listener for reply with description
    const replyListenerId = await bot.onReplyToMessage(query.message.chat.id, query.message.message_id, async (replymsg) => {
        try {
            //checks if description is longer than allowed
            if (replymsg.text.length > max_length.jio_description) {
                messenger.send(query.message.chat.id, DESCRIPTION_TOO_LONG_RESPONSE);
                return;
            }
            //update message in group chat
            const description = replymsg.from.first_name + " says: " + replymsg.text + "\n\n";
            await queries.storeJioDescription(data['chat_id'], description);
            const newMessageData = (await queries.getJioMessageData(msg.chat.id)).text;
            messenger.edit(
                data['chat_id'],
                msg.message_id,
                null,
                newMessageData + await queries.getOrderMessage(data['chat_id']),
                ikb.reply_markup
            );

            //update direct message to creator
            messenger.send(
                query.message.chat.id,
                DESCRIPTION_RECEIVED_RESPONSE,
                null,
                null,
            );
        } catch (err) {
            console.log(err);
        }
    });
    queries.storeListenerId(replyListenerId, msg.chat.id)
    const date = new Date();
    date.setDate(date.getDate() + 1);
}

const notifyOpenjioFailure = async function (err, query) {
    messenger.edit(
        query.message.chat.id,
        query.message.message_id,
        null,
        CREATION_FAILURE_TEMPLATE,
        null);
}
