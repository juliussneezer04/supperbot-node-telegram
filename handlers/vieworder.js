const queries = require('../db/queries');
const messenger = require('../messenger');
const sprintf = require("sprintf-js").sprintf;

module.exports.init = async function (msg) {
    //TODO: send initial message "getting your orders" then update when ready
    try {
        if (msg.chat.id === msg.from.id) {
            messenger.send(msg.chat.id, 'Please send your commands in the group!');
        } else if (!await queries.checkHasJio(msg.chat.id)){
            return;
        }

        // notify chat
        const text = await queries.getOrderMessage(msg.chat.id);
        await messenger.send(msg.chat.id, text, null);
    } catch (err) {
        console.log(err);
    }
}

const createOrderMessage = async function (chat_id) { //moved to queries
    const menu = await queries.getMenu({
        chat_id: chat_id,
    });
    const orders = await queries.getChatOrders({
        menu: menu,
        chat_id: chat_id,
    });

    if(orders.length === 0){
        return "There are no items ordered so far";
    }

    let result = 'The items ordered so far are: \n';
    for (let i = 0; i < orders.length; i++) {
        const order = orders[i];
        let remarks = order.remarks == null ? '' : sprintf(' (%s)', order.remarks);
        let modifiers = order.mods == null ? '' : sprintf(' (%s)', order.mods);
        result += sprintf('%s - %s%s%s x%s ($%.2f)\n',
            order.user, order.item, modifiers, remarks, order.count, order.price / 100.0);
    }
    return result;
}