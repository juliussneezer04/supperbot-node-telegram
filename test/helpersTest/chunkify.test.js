const chunkify = require('../../helpers/chunkify').chunkify;
const randomTextGenerator = require('../../helpers/randomTextGenerator').randomTextGenerator;
// const readTextFile = require('../../helpers/readTextFile').readTextFile;
const assert = require('assert');

const SMALL_CHAR_LIMIT = 101;
const TELEGRAM_CHAR_LIMIT = 4096;

/**
 * Testing suite for chunkify.js.
 * Method signature for Chunkify is (message, maxChars).
 */

describe('Chunkify', function () {
    /**
     * Tests whether valid message with only newlines within the TELEGRAM_CHAR_LIMIT is un-modified.
     */
    it('should not modify valid simple messages', function(done) {
        const actualChunkifiedMessage = chunkify("Valid Message", TELEGRAM_CHAR_LIMIT);
        assert.deepEqual(actualChunkifiedMessage, ["Valid Message"]);
        done();
    });

    /**
     * Tests whether large valid messages with only newlines containing SMALL_CHAR_LIMIT characters is un-modified.
     */
    it('should not modify valid messages at the CHAR_LIMIT', function(done) {
        // const testFilePath = "test/out_newline_101chars.txt";
        // const VALID_LIMIT_TEST_MESSAGE = readTextFile(testFilePath);
        const VALID_LIMIT_TEST_MESSAGE = randomTextGenerator(SMALL_CHAR_LIMIT);
        const actualChunkifiedMessage = chunkify(VALID_LIMIT_TEST_MESSAGE, 101);
        assert.deepEqual(actualChunkifiedMessage, [VALID_LIMIT_TEST_MESSAGE]);
        done();
    });
})