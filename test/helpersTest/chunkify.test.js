const chunkify = require('../../helpers/chunkify').chunkify;
const randomTextGenerator = require('../../helpers/randomTextGenerator').randomTextGenerator;
// const readTextFile = require('../../helpers/readTextFile').readTextFile;
const assert = require('assert');

const NEGATIVE_CHAR_LIMIT = -101;
const INVALID_CHAR_LIMIT = 0;
const SMALL_CHAR_LIMIT = 101;
const TELEGRAM_CHAR_LIMIT = 4096;
const EMPTY_STRING = "";

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
        const actualChunkifiedMessage = chunkify(VALID_LIMIT_TEST_MESSAGE, SMALL_CHAR_LIMIT);
        assert.deepEqual(actualChunkifiedMessage, [VALID_LIMIT_TEST_MESSAGE]);
        done();
    });

    /**
     * Tests whether chunkify accepts empty Strings.
     */
    it('should not throw error when empty String is passed', function(done) {
        assert.doesNotThrow(() => {chunkify(EMPTY_STRING, SMALL_CHAR_LIMIT)})
        done();
    });

    it('should split the message into chunks when message has more characters than CHAR_LIMIT', function(done) {
       const VALID_LARGER_THAN_LIMIT_MESSAGE = randomTextGenerator(SMALL_CHAR_LIMIT + SMALL_CHAR_LIMIT);
       const chunkifiedMessage = chunkify(VALID_LARGER_THAN_LIMIT_MESSAGE, SMALL_CHAR_LIMIT);
       assert(chunkifiedMessage.length > 1);
       done();
    });

    /**
     * Tests whether chunkify throws an error for invalid character limits.
     */
    it('should throw error when maxChars is less than 1', function(done) {
        assert.throws(
            () => {
                chunkify(EMPTY_STRING, INVALID_CHAR_LIMIT);
                chunkify(EMPTY_STRING, NEGATIVE_CHAR_LIMIT);
            }
        );
        done();
    });

})