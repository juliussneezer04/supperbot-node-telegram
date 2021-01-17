const util = require('util');
const queries = require('../db/queries');
const {menus, superusers, commands} = require('../config');
const sprintf = require("sprintf-js").sprintf;
const messenger = require('../messenger');
const {InlineKeyboard} = require("node-telegram-keyboard-wrapper");
const CLOSEJIO_CONFIRM_ID = commands.indexOf('closejioconfirm');
const CANCEL_COMMAND_ID = commands.indexOf('cancel');
const config = require('./config');
let bot;

module.exports.initbot = function (b) {
    bot = b;
}

module.exports.init = async function (msg) {
    try {
        const messageSender = await bot.getChatMember(msg.chat.id, msg.from.id);
        if (msg.chat.id === msg.from.id) {
            await messenger.send(msg.chat.id, 'Please send your commands in the group!');
            return;
        } else if (!await queries.checkHasJio(msg.chat.id)) {
            return;
        } else if (msg.from.id !== await queries.getJioCreatorId(msg.chat.id) &&
            messageSender.status !== "administrator" &&
            messageSender.status !== "creator" &&
            !superusers.includes(msg.from.id)) {
            //only allow group admin or group creator or jio starter to close
            await messenger.send(msg.chat.id, 'Only the jio creator or group admins can close the jio!');
            return;
        }

        //send confirmation message
        const ik = new InlineKeyboard();
        ik.addRow({
            text: 'Yes, close this jio',
            callback_data: JSON.stringify({
                t: CLOSEJIO_CONFIRM_ID,
                c: msg.chat.id
            })
        });
        ik.addRow({text: 'Cancel', callback_data: JSON.stringify({t: CANCEL_COMMAND_ID})});
        const text = 'Are you sure you want to close the jio in chat group \"' + msg.chat.title + '\"?';
        messenger.send(msg.from.id, text, ik.build(), msg.chat.id);

    } catch (err) {
        console.log(err);
    }
}

module.exports.callback = async function (query) {
    try {
        const data = JSON.parse(query.data);
        const chat_id = data.c;
        const menu = await queries.getMenu({
            chat_id: chat_id,
        });

        const deliveryFee = await queries.getFee({
            menu: menu,
        });

        // get all jio orders
        const compiledOrders = await queries.getOrderOverview({
            menu: menu,
            chat_id: chat_id,
        });

        // get individual user orders
        const userOrders = await queries.getChatOrders({
            menu: menu,
            chat_id: chat_id,
        });
        await queries.updateClosedJio(chat_id);
        // notify the chat
        const menuName = menus[menu];
        const closerName = query.from.first_name;
        const text = createOverviewMessage(menuName, closerName, compiledOrders, userOrders, deliveryFee);
        const message_id = await queries.getJioMessageID(chat_id);
        await messenger.send(chat_id, text, {reply_to_message_id: message_id});
        await queries.destroyListenerIds(chat_id)
        // destroy jio
        await queries.destroyJio({
            chat_id: chat_id,
        }); //should we await here?

        // edit the direct message to user
        const JIO_CLOSE_DIRECT_TEMPLATE = "You have successfully closed the jio for %s in chat group \"%s\"."
        const chat = await bot.getChat(chat_id);
        const chatName = chat.title;
        const text2 = util.format(JIO_CLOSE_DIRECT_TEMPLATE, menuName, chatName);
        messenger.edit(
            query.message.chat.id,
            query.message.message_id,
            null,
            text2,
            null);

        // notify users
        notifyUserOrders(query, userOrders, deliveryFee);
    } catch (err) {
        console.log(err);
    }
}

const createOverviewMessage = function (menuName, closerName, compiledOrders, userOrders, deliveryFee) {
    let result = 'This jio for ' + menuName + ' was successfully closed by ' + closerName;
    if (menuName === config.menus[0]) {
        result += '.You can place your order with Al Amaans by calling 67740637'
    }
    result += '.\n\n';
    //TODO: add jio closer name
    if (compiledOrders.length === 0) {
        return result + 'There are no items in this jio.';
    }
    result += 'The compiled list of ordered items is: \n';
    let total = 0;
    let users = {};

    // compile jio orders
    for (let i = 0; i < compiledOrders.length; i++) {
        let order = compiledOrders[i];
        let remarks = order.remarks == null ? '' : sprintf(' (%s)', order.remarks);
        let modifiers = order.mods == null ? '' : sprintf(' (%s)', order.mods);
        // insert all items into message
        result += sprintf('%s%s%s x %d\n', order.item, modifiers, remarks, order.count);
        total += order.price;
    }

    // compile individual prices
    for (let i = 0; i < userOrders.length; i++) {
        let order = userOrders[i];
        if (!users.hasOwnProperty(order.user_id)) {
            users[order.user_id] = [order.user, 0];
        }
        users[order.user_id][1] += order.price;
    }

    // Insert all user prices
    result += '\nEach person please pay:\n';
    for (const [, info] of Object.entries(users)) {
        let userDelivery = deliveryFee * info[1] / total;
        result += sprintf('%s - $%.2f(+%.2f)\n', info[0], info[1] / 100.0, userDelivery / 100.0);
    }

    // add overview
    result += sprintf('\nTotal cost: $%.2f(+%.2f)', total / 100.0, deliveryFee / 100.0);
    return result;
}

const notifyUserOrders = function (msg, userOrders, deliveryFee) {
    try {
        let totalPrice = 0;
        let users = {};

        // group all user orders
        for (let i = 0; i < userOrders.length; i++) {
            let order = userOrders[i];
            // init user if not present
            if (!users.hasOwnProperty(order.user_id)) {
                users[order.user_id] = {total: 0, items: []};
            }
            // append items
            totalPrice += order.price;
            users[order.user_id].total += order.price;
            users[order.user_id].items.push([order.item, order.count, order.remarks, order.mods]);
        }
        // notify each user
        for (const [user_id, info] of Object.entries(users)) {
            notifyUser(user_id, info.items, info.total, deliveryFee * info.total / totalPrice);
        }
    } catch (e) {
        console.log(e);
    }
}

const notifyUser = function (user_id, orders, total, delivery) {
    let text = sprintf('Your share will be $%.2f (+%.2f delivery) for:\n', total / 100.0, delivery / 100.0);
    // add all of the user's items
    for (let i = 0; i < orders.length; i++) {
        let order = orders[i];
        let remarks = order[2] == null ? '' : sprintf(' (%s)', order[2]);
        let modifiers = order[3] == null ? '' : sprintf(' (%s)', order[3]);
        text += sprintf('%s%s%s x %d\n', order[0], modifiers, remarks, order[1]);
    }
    messenger.send(user_id, text, {});
}

