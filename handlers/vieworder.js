const queries = require('../db/queries');
const messenger = require('../messenger');
const sprintf = require("sprintf-js").sprintf;

module.exports.init = async function (msg) {
    //TODO: send initial message "getting your orders" then update when ready
    try {
        if(!await queries.checkHasJio(msg.chat.id)){
            return;
        }
        // retrieve menu number
        let menu = await queries.getMenu({
            chat_id: msg.chat.id,
        });

        // get order counts
        let orders = await queries.getChatOrders({
            menu: menu,
            chat_id: msg.chat.id,
        });

        // notify chat
        const text = createOrderMessage(orders);
        await messenger.send(msg.chat.id, text, null);
    } catch (err) {
        console.log(err);
    }
}

const createOrderMessage = function (orders) {
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
