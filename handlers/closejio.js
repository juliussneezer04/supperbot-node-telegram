const queries = require('../db/queries');
const {menus, superusers} = require('../config');
const sprintf = require("sprintf-js").sprintf;
const messenger = require('../messenger');
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
        const menu = await queries.getMenu({
            chat_id: msg.chat.id,
        });

        const deliveryFee = await queries.getFee({
            menu: menu,
        });

        // get all jio orders
        const compiledOrders = await queries.getOrderOverview({
            menu: menu,
            chat_id: msg.chat.id,
        });

        // get individual user orders
        const userOrders = await queries.getChatOrders({
            menu: menu,
            chat_id: msg.chat.id,
        });
        await queries.updateClosedJio(msg.chat.id);
        // notify the chat
        const menuName = menus[menu];
        const closerName = msg.from.first_name;
        const text = createOverviewMessage(menuName, closerName, compiledOrders, userOrders, deliveryFee);
        const message_id = await queries.getJioMessageID(msg.chat.id);
        await messenger.send(msg.chat.id, text, {reply_to_message_id: message_id});
        await queries.destroyListenerIds(msg.chat.id)
        // destroy jio
        await queries.destroyJio({
            chat_id: msg.chat.id,
        }); //should we await here?

        // notify users
        notifyUserOrders(msg, userOrders, deliveryFee);
    } catch (err) {
        console.log(err);
    }
}

const createOverviewMessage = function (menuName, closerName, compiledOrders, userOrders, deliveryFee) {
    let result = 'This jio for ' + menuName + ' was successfully closed by ' + closerName + '.\n\n'
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

