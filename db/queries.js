const db = require('./db');
const menus = require('../config').menus; //TODO: make this a database entry
const messenger = require('../messenger');

const hasJio = async function (chat_id) {
    const statement = `select * from jiodata.jios where chat_id = $1`;
    const args = [chat_id];
    const res = await db.query(statement, args);
    return res.rowCount > 0;
}
module.exports.checkHasJio = async function (chat_id) {
    const hasJioValue = await hasJio(chat_id)
    if(!hasJioValue){
        const text = 'There is no jio open yet! Click on /openjio to get started!'
        messenger.send(chat_id, text, {});
    }
    return hasJioValue;
}

module.exports.hasJio = hasJio;

module.exports.openJio = async function (params, callback) {
    const statement = `
		insert into
			jiodata.jios	(chat_id, creator_id, creator_name, menu, duration)
			values			($1, $2, $3, $4, $5);`;
    const args = [params.chat_id, params.creator_id, params.creator_name, params.menu, params.duration];

    await db.query(statement, args, callback);
}

module.exports.addItem = async function (params, callback) {
    const statement = `
		insert into
			jiodata.orders 	(chat_id, user_id, user_name, item_id, message_id)
			values 			($1, $2, $3, $4, $5)
			returning		order_id;`;
    const args = [params.chat_id, params.user_id, params.user_name, params.item_id, params.message_id];

    const result = await db.query(statement, args, callback);
    return result.rows[0].order_id;
}

module.exports.addModifier = async function (params, callback) {
    const menuname = 'menudata.' + menus[params.menu].split(' ').join('_');
    const modmenuname = menuname + '_mod';
    const statement = `
		insert into
			jiodata.modifiers 	(order_id, name, price, level)
		select	$1 as order_id, name, price, level
				from	${modmenuname}
				where mod_id = $2;`;
    const args = [params.order_id, params.mod_id];

    await db.query(statement, args, callback);
}

module.exports.addRemark = async function (params, callback) {
    const statement = `
		update 	jiodata.orders
		set		remarks = $1
		where	message_id = $2;`;
    const args = [params.remarks, params.message_id];

    await db.query(statement, args, callback);
}

module.exports.hasOrder = async function (message_id) {
	const statement = `select * from jiodata.orders where message_id = $1;`;
	const args = [message_id];
	const res = await db.query(statement, args);
	return res.rowCount > 0;
}

module.exports.getModifierOptions = async function (params, callback) {
    const menuname = 'menudata.' + menus[params.menu].split(' ').join('_');
    const modmenuname = menuname + '_mod';
    const statement = `
		select t1.mod_id, t1.name, t1.price
		from ${modmenuname} t1
		where
			t1.group = 
				(select mod_group as group
				from 	${menuname}
				where	item_id = $1) and
			t1.level = $2;`;

    const args = [params.item_id, params.level];
    const res = await db.query(statement, args, callback);
    return res.rows;
}

module.exports.getMenu = async function (params, callback) {
    //TODO: cache in memory to speed up
    const statement = `
		select	menu 
			from	jiodata.jios
			where	chat_id = $1;`;
    const args = [params.chat_id];

    const res = await db.query(statement, args, callback);
    return res.rows[0].menu;
}

module.exports.getFee = async function (params, callback) { //delivery fee?
    const menuname = menus[params.menu].split(' ').join('_');
    const statement = `
		select	price 
			from	menudata.${menuname}
			where	item_id = 0;`;

    const ans = await db.query(statement, [], callback);
    return ans.rows[0].price;
}


module.exports.isTerminal = async function (params, callback) {
    const menuname = menus[params.menu].split(' ').join('_');

    const statement = `
		select not exists (
			select 1 from menudata.${menuname}
			where parent_id = $1
		) as exists;`;
    const args = [params.item_id];

    const ans = await db.query(statement, args, callback);
    return ans.rows[0].exists;
}


module.exports.getChildren = async function (params, callback) {
    const menuname = menus[params.menu].split(' ').join('_');

    const statement = `
		select 	item_id as id, item_name as name, price
		from 	menudata.${menuname}
		where 	parent_id = $1 and item_id != 0;`;
    const args = [params.item_id];

    const children = await db.query(statement, args, callback);
    return children.rows;
}


module.exports.getParent = async function (params, callback) {
    const menuname = menus[params.menu].split(' ').join('_');

    const statement = `
		select 	parent_id as parent
		from 	menudata.${menuname}
		where 	item_id = $1 and item_id != 0;`;
    const args = [params.item_id];

    const children = await db.query(statement, args, callback);
    return children.rows[0].parent;
}


module.exports.getItemName = async function (params, callback) {
    const menuname = menus[params.menu].split(' ').join('_');

    const statement = `
		select	item_name as name
		from	menudata.${menuname}
		where	item_id = $1;`;
    const args = [params.item_id];

    const res = await db.query(statement, args, callback);
    return res.rows[0].name;
}

module.exports.getUserOrders = async function (params, callback) {
    const menuname = menus[params.menu];
    const menutable = 'menudata.' + menuname.split(' ').join('_');

    const statement = `
		select 	order_id as id, t2.item_name as name 
		from 	jiodata.orders t1
		inner join ${menutable} t2
		on 		(t1.item_id = t2.item_id)
		where 	user_id = $1 and chat_id = $2;`;
    const args = [params.user_id, params.chat_id];

    const res = await db.query(statement, args, callback);
    return res.rows;
}

module.exports.getUserOrderCounts = async function (params, callback) {
    const menuname = menus[params.menu];
    const menutable = 'menudata.' + menuname.split(' ').join('_');

    const statement = `
		select 	t1.item_name as item, t2.count, t2.remarks, ((t1.price + t2.sum) * t2.count)::int as price, t2.mods
		from 	${menutable} t1
		join (
			select 	s1.item_id, count(*), s1.remarks, s2.mods, COALESCE(s2.sum, 0) as sum
			from 	jiodata.orders s1
			left join (
				select order_id, string_agg(name, ', ') as mods, sum(price)
				from jiodata.modifiers
				group by order_id
			) s2
			on		s1.order_id = s2.order_id
			where 	chat_id = $2 and user_id = $1
			group by item_id, mods, sum, remarks
		) t2
		on 		t1.item_id = t2.item_id
		order by t1.item_name;`;
    const args = [params.user_id, params.chat_id];

    const res = await db.query(statement, args, callback);
    return res.rows;
}

module.exports.getChatOrders = async function (params, callback) {
    const menutable = 'menudata.' + menus[params.menu].split(' ').join('_');
    const statement = `
		select 	t1.item_name as item, t2.remarks, t2.count, ((t1.price + t2.sum) * t2.count)::int as price, t2.mods, t3.user_name as user, t3.user_id
		from 	${menutable} t1 
		join (
			select 	s1.user_id, s1.item_id, count(*), s1.remarks, s2.mods, COALESCE(s2.sum, 0) as sum
			from 	jiodata.orders s1
			left join (
				select order_id, string_agg(name, ', ') as mods, sum(price)
				from jiodata.modifiers
				group by order_id
			) s2
			on		s1.order_id = s2.order_id
			where 	chat_id = $1
			group by user_id, item_id, mods, sum, remarks
		) t2
		on t1.item_id = t2.item_id
		join (
			select 	distinct user_id, user_name
			from 	jiodata.orders 
		) t3
		on 		t2.user_id = t3.user_id
		order by t3.user_name;`;

    const args = [params.chat_id];

    const res = await db.query(statement, args, callback);
    return res.rows;
}

module.exports.getOrderOverview = async function (params, callback) {
    const menuname = menus[params.menu];
    const menutable = 'menudata.' + menuname.split(' ').join('_');

    const statement = `
		select 	t1.item_name as item, t2.remarks, t2.count, ((t1.price + t2.sum) * t2.count)::int as price, t2.mods
		from 	${menutable} t1
		join (
			select 	s1.item_id, count(*), s1.remarks, s2.mods, COALESCE(s2.sum, 0) as sum
			from 	jiodata.orders s1
			left join (
				select 	order_id, string_agg(name, ', ') as mods, sum(price)
				from 	jiodata.modifiers s2
				group by order_id
			) s2
			on s1.order_id = s2.order_id
			where 	chat_id = $1
			group by item_id, remarks, mods, sum
		) t2
		on 		t1.item_id = t2.item_id
		order by t1.item_name;`;

    const args = [params.chat_id];

    const res = await db.query(statement, args, callback);
    return res.rows;
}

module.exports.destroyJio = async function (params, callback) {
    const statement = `
		delete from jiodata.jios
		where 	chat_id=$1;`;
    const args = [params.chat_id];

    await db.query(statement, args, callback);
}

module.exports.removeItem = async function (params, callback) {
    const statement = `
		delete from jiodata.orders
		where	order_id = $1 and user_id = $2;`;
    const args = [params.order_id, params.user_id];

    await db.query(statement, args, callback);
}