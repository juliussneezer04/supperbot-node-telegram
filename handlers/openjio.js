// var util = require('util');
var cloneextend = require('cloneextend');

// var queries = require('../db/queries');
var menus = require('../config').menus;
var commands = require('../config').commands;
const keyboard = require('node-telegram-keyboard-wrapper');

const OPEN_JIO_COMMAND_ID = commands.indexOf('openjio');
const CANCEL_COMMAND_ID = commands.indexOf('cancel');
const CREATION_SUCCESS_TEMPLATE = '%s created a jio for %s'
const CREATION_SUCCESS_TIME_TEMPLATE = ', with duration %s minutes.';
const CREATION_FAILURE_TEMPLATE = 'Jio already exists in the chat!'


module.exports.init = function (msg, bot) {
	//can receive the open jio command in a group, but the bot messages the user directly
	const ik = new keyboard.InlineKeyboard();
	for (let i=0; i<menus.length; i++) {
		let data = {t: OPEN_JIO_COMMAND_ID, chat_id: msg.chat.id, m: i}
		ik.addRow({text: menus[i], callback_data: JSON.stringify(data)})
	}
	ik.addRow({text:'Cancel', callback_data: JSON.stringify({t: CANCEL_COMMAND_ID})});
	bot.sendMessage(msg.from.id, 'What will you like for supper?', ik.build());
}


module.exports.callback = function (query, bot) {
	let data = JSON.parse(query.data);
	if (data.duration) {
		return
		// return commit(req, res, next);
	}
	const ik = new keyboard.InlineKeyboard();
	const duration_options = [
		['15 min', 15],
		['30 min', 30],
		['60 min', 60],
		['90 min', 90],
		['unlimited', -1]
	];
	for (const d of duration_options) {
		ik.addRow({text: d[0], callback_data: JSON.stringify(embed(data, {duration: d[1]}))});
	}
	ik.addRow({text:'Cancel', callback_data: JSON.stringify({t: CANCEL_COMMAND_ID})});
	bot.sendMessage(query.from.id, 'How long will you like the jio to be open for?', ik.build());
}

var embed = function (data, x) {
	return cloneextend.cloneextend(data, x);
}
//
// var commit = async function (req, res, next) {
// 	try {
// 		params = {
// 			chat_id: req.callback.data['chat_id'],
// 			creator_id: req.callback.from.id,
// 			creator_name: req.callback.from.first_name,
// 			duration: req.callback.data['duration'],
// 			menu: req.callback.data['m'],
// 		}
//
// 		await queries.openJio(params);
//
// 		notifyOpenjioSuccess(req);
//
// 	} catch (err) {
// 		notifyOpenjioFailure(err, req);
// 	}
// }
//
// var notifyOpenjioSuccess = function (req){
// 	// send success message to group
// 	text = util.format(CREATION_SUCCESS_TEMPLATE, req.callback.from.first_name,
// 			menus[req.callback.data['m']]);
// 	if (req.callback.data['duration'] != -1) { // if time is not unlimited
// 		text += util.format(CREATION_SUCCESS_TIME_TEMPLATE, req.callback.data['duration']);
// 	}
// 	msg.send(req.callback.data['chat_id'], text, null);
// 	// send success message to user
// 	text = 'Jio created!';
// 	msg.edit(req.callback.message.chat.id, req.callback.message.message_id, null, text, null);
// }
//
// var notifyOpenjioFailure = function (err, req) {
// 	console.log(err);
// 	text = CREATION_FAILURE_TEMPLATE;
// 	msg.edit(req.callback.message.chat.id, req.callback.message.message_id, null, text, null);
// }
