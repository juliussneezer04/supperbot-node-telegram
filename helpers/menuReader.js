const fs = require("fs");
const YAML = require("js-yaml");

class Menu {
    constructor(data) {
        this.delivery = data['Delivery'];
        this.instructions = data['Instructions']; // If instructions provided
        this.dishes = data['Menu'];
        this.modifiers = data['Modifiers'];
    }
}

// Returns menu object read from file
function getMenuFromFile(fileName) {
    try {
        const raw = fs.readFileSync(fileName, 'utf-8');
        const data = YAML.load(raw)
        const menu = new Menu(data);
        return menu;
    } catch (e) {
        console.log(e.name)
        throw e;
    }
}

exports.getMenuFromFile = getMenuFromFile;
exports.Menu = Menu;

// To print the result of the parsed yaml
// console.log(getMenuFromFile('../menu.yml'))
