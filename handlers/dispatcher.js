var parser = require('../parser/parser');
var openjio = require('./openjio');
var additem = require('./additem');
var removeitem = require('./removeitem');
var vieworder = require('./vieworder');
var viewmyorders = require ('./viewmyorders');
var closejio = require('./closejio');
var msg = require('../response/message');
var config = require('../config');
var commands = config.commands;


module.exports = function (req, res, next) {
	// dispatch to message handler or callback handler based on message contents
	if ('callback_query' in req.body) {
		dispatchCallback(req, res, next);
	}
	else if ('message' in req.body) {
		if ('reply_to_message' in req.body.message) {
			dispatchReply(req, res, next);
		}
		else {
			dispatchMessage(req, res, next);
		}
	}
}

var dispatchMessage = function (req, res, next) {
	// parse and dispatch
	req.message = parser.message(req.body['message']);
	// handle bot-specific commands
	if (req.message.text != null && req.message.text.includes('@')) {
		tokens = req.message.text.split('@');
		if (tokens[1] != config.bot_name) return;
		req.message.text = tokens[0];
	}
	switch (req.message.text) {
		case '/openjio':
			openjio.init(req, res, next);
			break;
		case '/closejio':
			closejio.init(req, res, next);
			break;
		case '/additem':
			additem.init(req, res, next);
			break;
		case '/removeitem':
			removeitem.init(req, res, next);
			break;
		case '/vieworder':
			vieworder.init(req, res, next);
			break;
		case '/viewmyorders':
			viewmyorders.init(req, res, next);
		case '/about':
			break;
		default:
			break;
	}
}

var dispatchCallback = function (req, res, next) {
	// parse and dispatch
	req.callback = parser.callback(req.body['callback_query']);
	req.callback_org = req.body['callback_query'];
	switch (commands[req.callback.data.t]) {
		case 'cancel':
			cancelCallback(req, res, next);
			break;
		case 'openjio':
			openjio.callback(req, res, next);
			break;
		case 'additem':
			additem.callback(req, res, next);
			break;
		case 'removeitem':
			removeitem.callback(req, res, next);
			break;
		case 'addmod':
			additem.callback_mod(req, res, next);
		default:
			break;
	}

}

var dispatchReply = function (req, res, next) {
	// parse and dispatch
	req.message = parser.message(req.body['message']);
	additem.reply(req, res, next);
}

var cancelCallback = function (req, res, next) {
	text = 'Your request has been cancelled!';
	msg.edit(req.callback.message.chat.id, req.callback.message.message_id, null, text, null);
}

