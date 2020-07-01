const queries = require('./queries');
const YAML = require('yaml')
const fs = require('fs');

async function run() {
    let root = {
        "name": "Al_Amaans",
        "id": 0
    }
    // root["children"] = await queries.getChildren({
    //     "menu": 0,
    //     "item_id": root["id"]
    // });

    async function populateChildren(item) {
        if (!await queries.isTerminal({
            "menu": 0,
            "item_id": item["id"]
        })) {
            item["children"] = await queries.getChildren({
                "menu": 0,
                "item_id": item["id"]
            });
            const children = item["children"];
            for (let i = 0; i < children.length; i++) {
                children[i] = await populateChildren(item["children"][i]);
            }
        }
        // get modifiers
        // let level = 0;
        // let modifiers = [];
        // let mod = true;
        // while(mod){
        //      let levelMod = await queries.getModifierOptions({
        //         "menu": 0,
        //         "item_id": item["id"],
        //         "level": level,
        //     });
        //      if(levelMod.length === 0){
        //          mod = false;
        //      } else{
        //          level++;
        //          modifiers.concat(levelMod);
        //      }
        // }
        if (item.hasOwnProperty("children")) {
            let obj = {};
            obj[item["name"]] = {};
            for (let i = 0; i < item["children"].length; i++) {
                Object.assign(obj[item["name"]], item["children"][i]);
            }
            return obj;
        } else {
            let obj = {};
            obj[item["name"]] = {"price": item["price"]};
            return obj;
        }
    }
    root = await populateChildren(root);

    const y = await YAML.stringify(root);
    fs.writeFile("menu.yml", y, () => {});
    return;
}
run();