const fs = require('fs');
const assert = require('assert');

function isFilePresent(path) {
    try {
        return fs.existsSync(path);
    } catch (err) {
        return false;
    }
}

function readTextFile(file)
{
    assert(isFilePresent(file), "Test Text File not present");
    return fs.readFileSync(file).toString("utf-8");
}

exports.readTextFile = readTextFile;