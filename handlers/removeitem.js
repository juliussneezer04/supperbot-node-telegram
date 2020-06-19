var queries = require('../db/queries');
var inline = require('../response/inlinekeyboard');
var commands = require('../config').commands;
var msg = require('../response/message');

const COMMAND_ID = commands.indexOf('removeitem');


module.exports.init = async function (msg, bot) {
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
        bot.sendMessage(msg.from.id, 'Failed to get user orders!', {});
    }
}

module.exports.callback = async function (query, bot) {
    try {
        // try removing item
        await queries.removeItem({
            user_id: query.from.id,
            order_id: query.data.p,
        });

        notifyRemoveitemSuccess(req);
    } catch (err) {
        notifyRemoveitemFailure(err, req);
    }
}


var sendList = function (msg, menu, items, bot) {
    text = 'What item will you like to remove?';
    kbdata = [];
    for (i = 0; i < items.length; i++) {
        item = items[i];
        kbdata.push([item.name, {t: COMMAND_ID, p: item.id}]);
    }
    kbdata.push(['Cancel', {t: 0}]);
    msg.send(msg.from.id, text, reply_markup = inline.keyboard(inline.button, kbdata), msg.chat.id);
}

var notifyNoItemsToRemove = function (msg, bot) {
    text = 'You have no items to remove!';
    msg.send(msg.from.id, text, null, msg.chat.id);
}

var notifyRemoveitemSuccess = function (query, bot) {
    text = 'Removed item!';
    msg.edit(query.message.chat.id, query.message.message_id, null, text, null);
}

var notifyRemoveitemFailure = function (err, query, bot) {
    console.log(err);
    text = 'Failed to remove item';
    msg.edit(query.message.chat.id, query.message.message_id, null, text, null);
}
