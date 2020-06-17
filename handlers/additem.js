var queries = require('../db/queries');
var commands = require('../config').commands;
var msg = require('../response/message');
const {InlineKeyboard} = require('node-telegram-keyboard-wrapper');

const COMMAND_ID = commands.indexOf('additem');
const MOD_COMMAND_ID = commands.indexOf('addmod');

//implement new menu data structure here
module.exports.init = async function (msg, bot) {
    try {
        var menu = await queries.getMenu({
            chat_id: msg.chat.id,
        });

        await sendMenu(msg, menu, bot);
    } catch (err) {
        console.log(err);
        bot.sendMessage(msg.chat.id, 'There is no jio open! Click /openjio to open one', {});
    }
}

module.exports.callback = async function (query, bot) {
    try {
        const data = JSON.parse(query.data);
        const is_terminal = await queries.isTerminal({
            item_id: data.p,
            menu: data.m,
        });

        if (is_terminal) {
            await commit(query, bot);
        } else {
            await sendChildren(query, bot);
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

module.exports.callback_mod = async function (query, bot) {
    try {
        const data = JSON.parse(query.data);
        await queries.addModifier({
            menu: data.m,
            order_id: data.o,
            mod_id: data.i,
        });

        sendModifierSelector(query, bot, data.o);
    } catch (err) {
        console.log(err);
    }
}

async function sendMenu(msg, menu, bot) {
    try {
        let children = await queries.getChildren({
            menu: menu,
            item_id: 0,
        });

        let kbdata = [];
        pushItems(menu, kbdata, children, null, msg.chat.id);
        const ik = new InlineKeyboard();
        for (const row of kbdata) {
            ik.addRow({text: kbdata[0], callback_data: JSON.stringify(kbdata[1])});
        }
        const text = 'What item will you like to add?';
        let r = bot.sendMessage(msg.from.id, text, ik.build());

    } catch (err) {
        console.log(err);
        bot.sendMessage(msg.from.id, 'Failed to get items!', {});
    }
}

var commit = async function (query, bot) {
    try {
        const data = JSON.parse(query.data);
        let order_id = await queries.addItem({
            chat_id: data.c,
            user_id: query.from.id,
            user_name: query.from.first_name,
            item_id: data.p,
            message_id: query.message.message_id,
        });

        await sendModifierSelector(query, bot, order_id);
    } catch (err) {
        notifyAdditemFailure(err, query, bot);
    }
}

var sendModifierSelector = async function (query, bot, order_id) {
    try {
        const data = JSON.parse(query.data);
        let itemName = await queries.getItemName({
            menu: data.m,
            item_id: data.p,
        });

        let level = data.hasOwnProperty('l') ? data.l + 1 : 0;

        let modifiers = await queries.getModifierOptions({
            menu: data.m,
            item_id: data.p,
            level: level,
        });

        if (modifiers.length == 0) {
            return notifyAdditemSuccess(req, itemName);
        }

        const text = `Customise your ${itemName}:\n`;
        kbdata = [];
        pushMods(data.m, kbdata, modifiers, level, order_id, data.p);
        const ik = new InlineKeyboard();
        for (const row of kbdata) {
            ik.addRow({text: kbdata[0], callback_data: JSON.stringify(kbdata[1])});
        }
        await bot.editMessageText(text, {chat_id: query.message.chat.id, message_id: query.message.message_id})
        await bot.editMessageReplyMarkup(ik.build().reply_markup, {
            chat_id: query.message.chat.id,
            message_id: query.message.message_id
        });
    } catch (err) {
        console.log(err); //send error message?
    }
}

var notifyAdditemSuccess = function (query, bot, itemName) {
    const text = itemName + ' added! Reply to this message to add remarks';
    bot.editMessageText( text, {chat_id: query.message.chat.id, message_id: query.message.message_id})
}

var notifyAdditemFailure = function (err, query, bot) {
    console.log(err);
    const text = 'Failed to add item';
    bot.editMessageText(text, {chat_id: query.message.chat.id, message_id: query.message.message_id})
}

var sendChildren = async function (query, bot) {
    const text = 'What item will you like to add?';
    try {
        const data = JSON.parse(query.data);
        let children = await queries.getChildren({
            menu: data.m,
            item_id: data.p,
        });

        let parent = null;
        if (data.p != 0) {
            parent = await queries.getParent({
                menu: data.m,
                item_id: data.p,
            });
        }

        kbdata = [];
        pushItems(data.m, kbdata, children, parent, data.c);
        msg.edit(query.message.chat.id, query.message.message_id, null, text, inline.keyboard(inline.button, kbdata));
    } catch (err) {
        console.log(err);
    }
}

var pushItems = function (menu, kbdata, children, parent, chat_id) {
    for (i = 0; i < children.length; i++) {
        kbdata.push([children[i].name, {t: COMMAND_ID, m: menu, p: children[i].id, c: chat_id}]);
    }
    if (parent != null) {
        kbdata.push(['Back', {t: COMMAND_ID, m: menu, p: parent, c: chat_id}]);
    }
    kbdata.push(['Cancel', {t: 0}]);
}

var pushMods = function (menu, kbdata, mods, level, order_id, item_id) {
    for (i = 0; i < mods.length; i++) {
        let mod = mods[i];
        kbdata.push([mod.name, {t: MOD_COMMAND_ID, o: order_id, m: menu, l: level, i: mod.mod_id, p: item_id}]);
    }
}
