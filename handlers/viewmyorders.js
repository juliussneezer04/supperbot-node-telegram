const queries = require('../db/queries');
const messenger = require('../messenger');
const sprintf = require("sprintf-js").sprintf;

module.exports.init = async function (msg) {
    try {
        if (msg.chat.id === msg.from.id) {
            messenger.send(msg.chat.id, 'Please send your commands in the group!');
        } else if (!await queries.checkHasJio(msg.chat.id)) {
            return;
        }
        // retrieve menu number
        let menu = await queries.getMenu({
            chat_id: msg.chat.id,
        });

        // get the user's orders, counts, and price
        let items = await queries.getUserOrderCounts({
            menu: menu,
            user_id: msg.from.id,
            chat_id: msg.chat.id,
        });

        // notify
        const text = createUserOrderMessage(items);
        messenger.send(msg.from.id, text, null, msg.from.id);

    } catch (err) {
        console.log(err);
    }
}

const createUserOrderMessage = function (items) {
    let result = 'Your items so far are: \n';
    let total = 0;
    for (let i = 0; i < items.length; i++) {
        const item = items[i];
        total += item.price;
        let remarks = item.remarks == null ? '' : sprintf(' (%s)', item.remarks);
        let modifiers = item.mods == null ? '' : sprintf(' (%s)', item.mods);
        result += sprintf('%s%s%s x%s ($%.2f)\n', item.item, modifiers, remarks, item.count, item.price / 100.0);
    }
    result += sprintf('Total: $%.2f', total / 100.0);
    return result;
}
