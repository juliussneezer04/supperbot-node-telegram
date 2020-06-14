var queries = require('../db/queries');
var util = require('util');
var msg = require('../response/message');
var sprintf = require("sprintf-js").sprintf;

module.exports.init = async function (req, res, next) {
	try {
		let menu = await queries.getMenu({
			chat_id: req.message.chat.id,
		});

		let deliveryFee = await queries.getFee({
			menu: menu,
		});

		// get all jio orders
		let compiledOrders = await queries.getOrderOverview({
			menu: menu,
			chat_id: req.message.chat.id,
		});

		// get individual user orders
		let userOrders = await queries.getChatOrders({
			menu: menu,
			chat_id: req.message.chat.id,
		});

		// notify the chat
		text = createOverviewMessage(compiledOrders, userOrders, deliveryFee);
		msg.send(req.message.chat.id, text, null);

		// destroy jio
		queries.destroyJio({
			chat_id: req.message.chat.id,
		});

		// notify users
		notifyUserOrders(req, userOrders, deliveryFee);
	} catch (err) {
		console.log(err);
		text = 'There is no jio open yet! Click on /openjio to get started!'
		msg.send(req.message.chat.id, text, null);
	}
}

var createOverviewMessage = function (compiledOrders, userOrders, deliveryFee) {
	result = 'Jio closed!\nThe compiled list of ordered items is: \n';
	total = 0;
	var users = {};

	// compile jio orders
	for (var i=0; i<compiledOrders.length; i++) {
		order = compiledOrders[i];
		let remarks = order.remarks == null ? '' : sprintf(' (%s)', order.remarks);
		let modifiers = order.mods == null ? '' : sprintf(' (%s)', order.mods);
		// insert all items into message
		result += sprintf('%s%s%s x %d\n', order.item, modifiers, remarks, order.count);
		total += order.price;
	}

	// compile individual prices
	for (var i=0; i<userOrders.length; i++) {
		order = userOrders[i];

		if (!users.hasOwnProperty(order.user_id)) {
			users[order.user_id] = [order.user, 0];
		}
		users[order.user_id][1] += order.price;
	}

	// Insert all user prices
	result += '\nEach person please pay:\n';
	for (const [user_id, info] of Object.entries(users)) {
		let userDelivery = deliveryFee * info[1] / total;
		result += sprintf('%s - $%.2f(+%.2f)\n', info[0], info[1]/100.0, userDelivery/100.0);
	}
	
	// add overview
	result += sprintf('\nTotal cost: $%.2f(+%.2f)', total/100.0, deliveryFee/100.0);
	return result;
}

var notifyUserOrders = function (req, orders, deliveryFee) {
	if (!orders) return;
	let totalPrice = 0;
	var users = {};

	// group all user orders
	for (var i=0; i<orders.length; i++) {
		order = orders[i];

		// init user if not present
		if (!users.hasOwnProperty(order.user_id)) {
			users[order.user_id] = {total: 0, items: []};
		}

		// append items
		totalPrice += order.price;
		users[order.user_id].total += order.price;
		users[order.user_id].items.push([order.item, order.count, order.remarks, order.mods]);
	}

	// notify each and every user
	for (const [user_id, info] of Object.entries(users)) {
    	notifyUser(user_id, info.items, info.total, deliveryFee * info.total / totalPrice);
	}
}

var notifyUser = function (user_id, orders, total, delivery) {
	let text = sprintf('Your share will be $%.2f (+%.2f delivery) for:\n', total/100.0, delivery/100.0);
	// add all of the user's items
	for (var i=0; i<orders.length; i++) {
		let order = orders[i];
		let remarks = order[2] == null ? '' : sprintf(' (%s)', order[2]);
		let modifiers = order[3] == null ? '' : sprintf(' (%s)', order[3]);
		text += sprintf('%s%s%s x %d\n', order[0], modifiers, remarks, order[1]);
	}
	msg.send(user_id, text, null);
}

