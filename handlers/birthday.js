const messenger = require('../messenger');
const queries = require('../db/queries');

module.exports.birthday = async function (msg) {
    const originalText = msg.text;
    const lowerText = originalText.toLowerCase();
    const stringsToMatch = ["happybirthday", "happybday"];
    let matched = false;
    for (const str of stringsToMatch) {
        if (lowerText.indexOf(str) === 1) {
            matched = true;
            break;
        }
    }
    if (matched) {
        const count = await queries.repeatCount(originalText);
        if (count === 9) {
            messenger.send(msg.chat.id, originalText)
        }
    }
}