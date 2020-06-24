const queries = require('./queries');
const YAML = require('yaml')
const fs = require('fs');

async function run() {
    const root = {
        "name": "Al_Amaans",
        "id": 0
    }
    root["children"] = await queries.getChildren({
        "menu": 0,
        "item_id": root["id"]
    });

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
        delete item["id"];
        if (item.hasOwnProperty("children")) {
            item[item["name"]] = item["children"];
            delete item["children"];
            delete item["name"];
        } else {
            return item["name"];
        }
        return item;
    }
    await populateChildren(root);

    const y = YAML.stringify(root);
    fs.writeFile("menu.yml", y, () => {});
    return;
}
run();