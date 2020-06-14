var queries = require('../db/queries');
var inline = require('../response/inlinekeyboard');
var commands = require('../config').commands;
var msg = require('../response/message');

const COMMAND_ID = commands.indexOf('removeitem');


module.exports.init = async function (req, res, next) {
	try {
		// retrieve menu number
		let menu = await queries.getMenu({
			chat_id: req.message.chat.id,
		});

		// get user orders
		let items = await queries.getUserOrders({
			menu: menu,
			user_id: req.message.from.id,
			chat_id: req.message.chat.id,
		});

		// send inline menu or notify
		if (items.length == 0) {
			notifyNoItemsToRemove(req);
		}
		else {
			sendList(req, menu, items);
		}
		
	} catch (err) {
		console.log(err);
		msg.send(req.message.from.id, 'Failed to get user orders!', null);
	}
}

module.exports.callback = async function (req, res, next) {
	try {
		// try removing item
		await queries.removeItem({
			user_id: req.callback.from.id,
			order_id: req.callback.data.p,
		});

		notifyRemoveitemSuccess(req);
	} catch (err) {
		notifyRemoveitemFailure(err, req);
	}
}


var sendList = function (req, menu, items) {
	text = 'What item will you like to remove?';
	kbdata = [];
	for (i=0; i<items.length; i++) {
		item = items[i];
		kbdata.push([item.name, {t: COMMAND_ID, p: item.id}]);
	}
	kbdata.push(['Cancel', {t: 0}]);
	msg.send(req.message.from.id, text, reply_markup=inline.keyboard(inline.button, kbdata), req.message.chat.id);
}

var notifyNoItemsToRemove = function (req) {
	text = 'You have no items to remove!';
	msg.send(req.message.from.id, text, null, req.message.chat.id);
}

var notifyRemoveitemSuccess = function (req) {
	text = 'Removed item!';
	msg.edit(req.callback.message.chat.id, req.callback.message.message_id, null, text, null);
}

var notifyRemoveitemFailure = function (err, req) {
console.log(err);
	text = 'Failed to remove item';
	msg.edit(req.callback.message.chat.id, req.callback.message.message_id, null, text, null);
}
