var queries = require('../db/queries');
var util = require('util');
var msg = require('../response/message');
var sprintf = require("sprintf-js").sprintf;

module.exports.init = async function (req, res, next) {
	try {
		// retrieve menu number
		let menu = await queries.getMenu({
			chat_id: req.message.chat.id,
		});

		// get the user's orders, counts, and price
		let items = await queries.getUserOrderCounts({
			menu: menu,
			user_id: req.message.from.id,
			chat_id: req.message.chat.id,
		});

		// notify
		text = createUserOrderMessage(items);
		msg.send(req.message.from.id, text, null, req.message.from.id);

	} catch (err) {
		console.log(err);
		text = 'There is no jio open yet! Click on /openjio to get started!'
		msg.send(req.message.chat.id, text, null);
	}
}

var createUserOrderMessage = function (items) {
	result = 'Your items so far are: \n';
	total = 0;
	for (var i=0; i<items.length; i++) {
		item = items[i];
		total += item.price;
		let remarks = item.remarks == null ? '' : sprintf(' (%s)', item.remarks);
		let modifiers = item.mods == null ? '' : sprintf(' (%s)', item.mods);
		result += sprintf('%s%s%s x%s ($%.2f)\n', item.item, modifiers, remarks, item.count, item.price/100.0);
	}
	result += sprintf('Total: $%.2f', total / 100.0);
	return result;
}
