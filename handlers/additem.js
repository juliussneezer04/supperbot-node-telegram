const queries = require('../db/queries');
const commands = require('../config').commands;
const messenger = require('../messenger');
const {InlineKeyboard} = require('node-telegram-keyboard-wrapper');
const sprintf = require("sprintf-js").sprintf;
const COMMAND_ID = commands.indexOf('additem');
const MOD_COMMAND_ID = commands.indexOf('addmod');

//implement new menu data structure here
module.exports.init = async function (msg) {
    //TODO: make this into a inline button below the successful openjio message
    try {
        if (msg.chat.id === msg.from.id) {
            messenger.send(msg.chat.id, 'Please send your commands in the relevant group chat!');
        } else if (!await queries.checkHasJio(msg.chat.id)) {
            return;
        }
        const menu = await queries.getMenu({
            chat_id: msg.chat.id,
        });
        await sendMenu(msg, menu);

    } catch (err) {
        console.log(err);
    }
}

module.exports.callback = async function (query) {
    try {
        const data = JSON.parse(query.data);
        const is_terminal = await queries.isTerminal({
            item_id: data.p,
            menu: data.m,
        });

        if (is_terminal) {
            await commit(query);
        } else {
            await sendChildren(query);
        }
    } catch (err) {
        console.log(err);
    }
}

module.exports.reply = async function (msg) {
    try {
        if (await queries.hasOrder(msg.reply_to_message.message_id)) {
            await queries.addRemark({
                remarks: msg.text,
                message_id: msg.reply_to_message.message_id,
            });
            messenger.send(msg.chat.id, 'Remark added successfully!');
        }
        //TODO: send success message
    } catch (err) {
        console.log(err);
    }
}

module.exports.callback_mod = async function (query) {
    try {
        const data = JSON.parse(query.data);
        await queries.addModifier({
            menu: data.m,
            order_id: data.o,
            mod_id: data.i,
        });

        await sendModifierSelector(query, data.o);
    } catch (err) {
        console.log(err);
    }
}

async function sendMenu(msg, menu) {
    try {
        let children = await queries.getChildren({
            menu: menu,
            item_id: 0,
        });

        let kbdata = [];
        pushItems(menu, kbdata, children, null, msg.chat.id);
        const ik = new InlineKeyboard();
        for (const row of kbdata) {
            ik.addRow({text: row[0], callback_data: JSON.stringify(row[1])});
        }
        const text = 'What item will you like to add?';
        // let r = bot.sendMessage(msg.from.id, text, ik.build());
        await messenger.send(msg.from.id, text, ik.build(), msg.chat.id);
    } catch (err) {
        console.log(err);
        await messenger.send(msg.from.id, 'Failed to get items!', {}, msg.chat.id);
    }
}

const commit = async function (query) {
    try {
        const data = JSON.parse(query.data);
        let order_id = await queries.addItem({
            chat_id: data.c,
            user_id: query.from.id,
            user_name: query.from.first_name,
            item_id: data.p,
            message_id: query.message.message_id,
        });
        //TODO: wait for modifier before committing to DB?
        //TODO: add call to update live order here? (after modifiers and remarks)
        await sendModifierSelector(query, order_id);
    } catch (err) {
        await notifyAdditemFailure(err, query);
    }
}

const sendModifierSelector = async function (query, order_id) {
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

        if (modifiers.length === 0) {
            return notifyAdditemSuccess(query, itemName, order_id);
        }

        const text = `Customise your ${itemName}:\n`;
        let kbdata = [];
        pushMods(data.m, kbdata, modifiers, level, order_id, data.p);
        const ik = new InlineKeyboard();
        for (const row of kbdata) {
            ik.addRow({text: row[0], callback_data: JSON.stringify(row[1])});
        }
        await messenger.edit(
            query.message.chat.id,
            query.message.message_id,
            null,
            text,
            ik.build().reply_markup);
    } catch (err) {
        console.log(err); //send error message?
    }
}

const notifyAdditemSuccess = async function (query, itemName, order_id) {
    const text = itemName + ' added! Reply to this message to add remarks';
    await messenger.edit(
        query.message.chat.id,
        query.message.message_id,
        null,
        text,
        {});
    // TODO: update live message, use order_id to get chat_id
    //   queries.updateOrder(order_id, vieworder.getOrder())
}

const notifyAdditemFailure = async function (err, query) {
    console.log(err);
    const text = 'Failed to add item';
    await messenger.edit(
        query.message.chat.id,
        query.message.message_id,
        null,
        text,
        {});
}

const sendChildren = async function (query) {
    const text = 'What item will you like to add?';
    try {
        const data = JSON.parse(query.data);
        let children = await queries.getChildren({
            menu: data.m,
            item_id: data.p,
        });

        let parent = null;
        if (data.p !== 0) {
            parent = await queries.getParent({
                menu: data.m,
                item_id: data.p,
            });
        }

        let kbdata = [];
        pushItems(data.m, kbdata, children, parent, data.c);
        const ik = new InlineKeyboard();
        for (const row of kbdata) {
            ik.addRow({text: row[0], callback_data: JSON.stringify(row[1])});
        }
        await messenger.edit(
            query.message.chat.id,
            query.message.message_id,
            null,
            text,
            ik.build().reply_markup);
    } catch (err) {
        console.log(err);
    }
}

const pushItems = function (menu, kbdata, children, parent, chat_id) {
    for (let i = 0; i < children.length; i++) {
        if (children[i].price === null) {
            kbdata.push([children[i].name, {t: COMMAND_ID, m: menu, p: children[i].id, c: chat_id}]);
        } else {
            kbdata.push([sprintf("%s ($%.2f)", children[i].name, children[i].price / 100.0), {
                t: COMMAND_ID,
                m: menu,
                p: children[i].id,
                c: chat_id
            }]);
        }
    }
    if (parent != null) {
        kbdata.push(['Back', {t: COMMAND_ID, m: menu, p: parent, c: chat_id}]);
    }
    kbdata.push(['Cancel', {t: 0}]);
}

const pushMods = function (menu, kbdata, mods, level, order_id, item_id) {
    for (let i = 0; i < mods.length; i++) {
        let mod = mods[i];
        kbdata.push([sprintf("%s ($%.2f)", mod.name, mod.price / 100.0), {
            t: MOD_COMMAND_ID,
            o: order_id,
            m: menu,
            l: level,
            i: mod.mod_id,
            p: item_id
        }]);
    }
}
