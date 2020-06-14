var queries = require('../db/queries');
var inline = require('../response/inlinekeyboard');
var commands = require('../config').commands;
var msg = require('../response/message');

const COMMAND_ID = commands.indexOf('additem');
const MOD_COMMAND_ID = commands.indexOf('addmod');


module.exports.init = async function (req, res, next) {
	try {
		var menu = await queries.getMenu({
			chat_id: req.message.chat.id,
		});

		sendMenu(req, menu);
	} catch (err) {
		console.log(err);
		msg.send(req.message.chat.id, 'There is no jio open! Click /openjio to open one', null);
	}
}

module.exports.callback = async function (req, res, next) {
	try {
		let is_terminal = await queries.isTerminal({
			item_id: req.callback.data.p,
			menu: req.callback.data.m,
		});

		if (is_terminal) {
			commit(req, res, next);
		} else {
			sendChildren(req, res, next);
		}
	} catch (err) {
		console.log(err);
	}
}

module.exports.reply = async function (req, res, next) {
	try {
		await queries.addRemark({
			remarks: req.message.text,
			message_id: req.message.reply_to_message.message_id,
		});
	} catch (err) {
		console.log(err);
	}
}

module.exports.callback_mod = async function (req, res, next) {
	try {
		await queries.addModifier({
			menu: req.callback.data.m,
			order_id: req.callback.data.o,
			mod_id: req.callback.data.i,
		});

		sendModifierSelector(req, req.callback.data.o);
	} catch (err) {
		console.log(err);
	}
}

async function sendMenu(req, menu) {
	try {
		children = await queries.getChildren({
			menu: menu,
			item_id: 0,
		});

		text = 'What item will you like to add?';
		kbdata = [];
		pushItems(menu, kbdata, children, null, req.message.chat.id);
		msg.send(req.message.from.id, text, reply_markup=inline.keyboard(inline.button, kbdata), req.message.chat.id);

	} catch (err) {
		console.log(err);
		msg.send(req.message.from.id, 'Failed to get items!', null);
	}
}


var commit = async function (req, res, next) {
	try {
		let order_id = await queries.addItem({
			chat_id: req.callback.data.c,
			user_id: req.callback.from.id,
			user_name: req.callback.from.first_name,
			item_id: req.callback.data.p,
			message_id: req.callback.message.message_id,
		});

		sendModifierSelector(req, order_id);
	} catch (err) {
		notifyAdditemFailure(err, req);
	}
}

var sendModifierSelector = async function (req, order_id) {
	try {
		let itemName = await queries.getItemName({
			menu: req.callback.data.m,
			item_id: req.callback.data.p,
		});

		let level = req.callback.data.hasOwnProperty('l') ? req.callback.data.l + 1 : 0;

		let modifiers = await queries.getModifierOptions({
			menu: req.callback.data.m,
			item_id: req.callback.data.p,
			level: level,
		});

		if (modifiers.length == 0) {
			return notifyAdditemSuccess(req, itemName);
		}

		text = `Customise your ${itemName}:\n`;
		kbdata = [];
		pushMods(req.callback.data.m, kbdata, modifiers, level, order_id, req.callback.data.p);
		msg.edit(req.callback.message.chat.id, req.callback.message.message_id, null, text, inline.keyboard(inline.button, kbdata));
	} catch (err) {
		console.log(err);
	}
}

var notifyAdditemSuccess = function (req, itemName) {
	text = itemName + ' added! Reply to this message to add remarks';
	msg.edit(req.callback.message.chat.id, req.callback.message.message_id, null, text, null);
}

var notifyAdditemFailure = function (err, req) {
	console.log(err);
	text = 'Failed to add item';
	msg.edit(req.callback.message.chat.id, req.callback.message.message_id, null, text, null);
}

var sendChildren = async function (req, res, next) {
	text = 'What item will you like to add?';
	try {
		let children = await queries.getChildren({
			menu: req.callback.data.m,
			item_id: req.callback.data.p,
		});

		let parent = null;
		if (req.callback.data.p != 0) {
			parent = await queries.getParent({
				menu: req.callback.data.m,
				item_id: req.callback.data.p,
			});
		}
		
		kbdata = [];
		pushItems(req.callback.data.m, kbdata, children, parent, req.callback.data.c);
		msg.edit(req.callback.message.chat.id, req.callback.message.message_id, null, text, inline.keyboard(inline.button, kbdata));
	} catch (err) {
		console.log(err);
	}
}

var pushItems = function (menu, kbdata, children, parent, chat_id) {
	for (i=0; i<children.length; i++) {
		kbdata.push([children[i].name, {t: COMMAND_ID, m: menu, p: children[i].id, c: chat_id}]);
	}
	if (parent != null) {
		kbdata.push(['Back', {t: COMMAND_ID, m: menu, p: parent, c: chat_id}]);
	}
	kbdata.push(['Cancel', {t: 0}]);
}

var pushMods = function (menu, kbdata, mods, level, order_id, item_id) {
	for (i=0; i<mods.length; i++) {
		let mod = mods[i];
		kbdata.push([mod.name, {t: MOD_COMMAND_ID, o: order_id, m: menu, l: level, i: mod.mod_id, p: item_id}]);
	}
}
