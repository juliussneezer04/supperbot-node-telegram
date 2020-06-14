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

		// get order counts
		let orders = await queries.getChatOrders({
			menu: menu,
			chat_id: req.message.chat.id,
		});

		// notify chat
		text = createOrderMessage(orders);
		msg.send(req.message.chat.id, text, null);
	} catch (err) {
		console.log(err);
		text = 'There is no jio open yet! Click on /openjio to get started!'
		msg.send(req.message.chat.id, text, null);
	}
}

var createOrderMessage = function (orders) {
	result = 'The items ordered so far are: \n';
	for (var i=0; i<orders.length; i++) {
		order = orders[i];
		let remarks = order.remarks == null ? '' : sprintf(' (%s)', order.remarks);
		let modifiers = order.mods == null ? '' : sprintf(' (%s)', order.mods);
		result += sprintf('%s - %s%s%s x%s ($%.2f)\n',
			order.user, order.item, modifiers, remarks, order.count, order.price/100.0);
	}
	return result;
}
