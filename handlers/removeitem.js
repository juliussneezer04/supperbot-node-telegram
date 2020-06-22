const queries = require('../db/queries');
const commands = require('../config').commands;
const messenger = require('../messenger');
const {InlineKeyboard} = require("node-telegram-keyboard-wrapper");

const COMMAND_ID = commands.indexOf('removeitem');

module.exports.init = async function (msg) {
    try {
        // retrieve menu number
        let menu = await queries.getMenu({
            chat_id: msg.chat.id,
        });

        // get user orders
        let items = await queries.getUserOrders({
            menu: menu,
            user_id: msg.from.id,
            chat_id: msg.chat.id,
        });

        // send inline keyboard of user's orders or notify that there are no items
        if (items.length === 0) {
            notifyNoItemsToRemove(msg);
        } else {
            sendList(msg, menu, items);
        }
    } catch (err) {
        console.log(err);
        await messenger.send(msg.from.id, 'Failed to get user orders!', {}, msg.chat.id);
    }
}

module.exports.callback = async function (query) {
    try {
        // try removing item
        await queries.removeItem({
            user_id: query.from.id,
            order_id: query.data.p,
        });

        notifyRemoveitemSuccess(query);
    } catch (err) {
        notifyRemoveitemFailure(err, query);
    }
}

const sendList = function (msg, menu, items) {
    const text = 'What item will you like to remove?';
    const ik = new InlineKeyboard();
    for (let i = 0; i < items.length; i++) {
        const item = items[i];
        ik.addRow({text: item.name, callback_data: JSON.stringify({t: COMMAND_ID, p: item.id})});
    }
    ik.addRow({text: 'Cancel', callback_data: JSON.stringify({t: 0})})
    messenger.send(msg.from.id, text, ik.build(), msg.chat.id);
};

const notifyNoItemsToRemove = function (msg) {
    const text = 'You have no items to remove!';
    messenger.send(msg.from.id, text, null, msg.chat.id);
};

const notifyRemoveitemSuccess = function (query) {
    const text = 'Removed item!';
    messenger.edit(query.message.chat.id, query.message.message_id, null, text, null);
};

const notifyRemoveitemFailure = function (err, query) {
    console.log(err);
    const text = 'Failed to remove item';
    messenger.edit(query.message.chat.id, query.message.message_id, null, text, null);
};

