const chunkify = require('../chunkify').chunkify;
const readTextFile = require('../readTextFile').readTextFile;
const assert = require('assert');
const should = require('should');

const TELEGRAM_CHAR_LIMIT = 4096;

/**
 * Testing suite for chunkify.js.
 * Method signature for Chunkify is (message, maxChars).
 */

describe('Chunkify', function () {
    /**
     * Tests whether valid message within a specified CHAR_LIMIT is un-modified.
     */
    it('should not modify valid simple messages', function(done) {
        const actualChunkifiedMessage = chunkify("Valid Message", TELEGRAM_CHAR_LIMIT);
        assert.deepEqual(actualChunkifiedMessage, ["Valid Message"]);
        done();
    });

    /**
     * Tests whether large valid messages containing CHAR_LIMIT characters is un-modified.
     */
    it('Does not modify valid large messages', function(done) {
        const testFilePath = "helpers/test/out_newline.txt";
        const VALID_LARGE_TEST_MESSAGE = readTextFile(testFilePath);
        const actualChunkifiedMessage = chunkify(VALID_LARGE_TEST_MESSAGE, TELEGRAM_CHAR_LIMIT);
        assert.deepEqual(actualChunkifiedMessage, [VALID_LARGE_TEST_MESSAGE]);
        done();
    });
})