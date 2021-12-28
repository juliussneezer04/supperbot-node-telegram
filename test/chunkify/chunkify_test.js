const chunkify = require('../../helper/chunkify').chunkify;
const randomTextGenerator = require('../commons/randomTextGenerator').randomTextGenerator;
const readTextFile = require('../commons/readTextFile').readTextFile;
const assert = require('assert');

const SMALL_CHAR_LIMIT = 60;
const TELEGRAM_CHAR_LIMIT = 4096; //Telegram supports up to 4096 UTF-8 characters

const EMPTY_STRING = "";

/**
 * Testing suite for chunkify.js.
 * Method signature for Chunkify is (message, maxChars).
 */

describe('Chunkify', function () {
    /**
     * Tests whether error is thrown when an EMPTY_STRING and valid CHAR_LIMIT is passed.
     */
    it('should not throw an error when an empty String is passed in with valid CHAR_LIMIT', function(done) {
        assert.doesNotThrow(() => {chunkify(EMPTY_STRING, SMALL_CHAR_LIMIT)});
        done();
    });

    /**
     * Tests whether randomized valid message within a specified CHAR_LIMIT is un-modified.
     */

    it('should not modify valid simple messages', function(done) {
        const actualChunkifiedMessage = chunkify("Valid Message", TELEGRAM_CHAR_LIMIT);
        assert.deepEqual(actualChunkifiedMessage, ["Valid Message"]);
        done();
    });

    /**
     * Tests whether small valid messages containing CHAR_LIMIT characters is un-modified.
     */

    it('should not modify valid small messages (randomized + fixed input)', function(done) {
        const RANDOM_VALID_SMALL_TEST_MESSAGE = randomTextGenerator(SMALL_CHAR_LIMIT);
        const testFilePath = "test/chunkify/testInputSmall.txt";
        const FIXED_VALID_SMALL_TEST_MESSAGE = readTextFile(testFilePath);

        const actualChunkifiedMessageRandom = chunkify(RANDOM_VALID_SMALL_TEST_MESSAGE, SMALL_CHAR_LIMIT);
        const actualChunkifiedMessageFixed = chunkify(FIXED_VALID_SMALL_TEST_MESSAGE, SMALL_CHAR_LIMIT);

        //test: random valid text input, invalid number of characters
        assert.deepEqual(actualChunkifiedMessageRandom, [RANDOM_VALID_SMALL_TEST_MESSAGE]);

        //test: fixed valid text input, invalid number of characters
        assert.deepEqual(actualChunkifiedMessageFixed, [FIXED_VALID_SMALL_TEST_MESSAGE]);
        done();
    });

    /**
     * Tests whether large valid messages containing CHAR_LIMIT characters is un-modified.
     */

    it('should not modify valid large messages (randomized + fixed input)', function(done) {
        const RANDOM_VALID_LARGE_TEST_MESSAGE = randomTextGenerator(TELEGRAM_CHAR_LIMIT);
        const testFilePath = "test/chunkify/testInput.txt";
        const FIXED_VALID_LARGE_TEST_MESSAGE = readTextFile(testFilePath);

        const actualChunkifiedMessageRandom = chunkify(RANDOM_VALID_LARGE_TEST_MESSAGE, TELEGRAM_CHAR_LIMIT);
        const actualChunkifiedMessageFixed = chunkify(FIXED_VALID_LARGE_TEST_MESSAGE, TELEGRAM_CHAR_LIMIT);

        //test: random valid text input, invalid number of characters
        assert.deepEqual(actualChunkifiedMessageRandom, [RANDOM_VALID_LARGE_TEST_MESSAGE]);

        //test: fixed valid text input, invalid number of characters
        assert.deepEqual(actualChunkifiedMessageFixed, [FIXED_VALID_LARGE_TEST_MESSAGE]);
        done();
    });

    /**
     * Tests whether large messages containing number of characters greater than CHAR_LIMIT characters
     * are modified appropriately.
     */

    it('should split large message into and return an array of strings with strictly positive size less than the char limit (randomized + fixed input)', function(done) {
        const RANDOM_LARGE_TEST_MESSAGE = randomTextGenerator(TELEGRAM_CHAR_LIMIT * 2);
        const testFilePath = "test/chunkify/testInputLarge.txt";
        const FIXED_LARGE_TEST_MESSAGE = readTextFile(testFilePath);

        const actualChunkifiedMessageRandom = chunkify(RANDOM_LARGE_TEST_MESSAGE, TELEGRAM_CHAR_LIMIT);
        const actualChunkifiedMessageFixed = chunkify(FIXED_LARGE_TEST_MESSAGE, TELEGRAM_CHAR_LIMIT);

        //test: random valid text input, invalid number of characters
        for (let i = 0; i < actualChunkifiedMessageRandom.length; ++i) {
            assert(actualChunkifiedMessageRandom[i].length > 0 && actualChunkifiedMessageRandom[i].length <= TELEGRAM_CHAR_LIMIT);
        }

        //test: fixed valid text input, invalid number of characters
        for (let i = 0; i < actualChunkifiedMessageFixed.length; ++i) {
            assert(actualChunkifiedMessageFixed[i].length > 0 && actualChunkifiedMessageFixed[i].length <= TELEGRAM_CHAR_LIMIT);
        }

        done();
    });

    /**
     * Tests whether exception is thrown when invalid/negative CHAR_LIMIT are passed into chunkify
     */

    it('should throw error when maxChars is less than 1', function(done) {
        const testFilePath = "test/chunkify/testInputSmall.txt";
        const FIXED_VALID_SMALL_TEST_MESSAGE = readTextFile(testFilePath);
        const RANDOM_VALID_SMALL_TEST_MESSAGE = randomTextGenerator(SMALL_CHAR_LIMIT);

        //test: empty String input, invalid number of characters
        assert.throws(
            () => {
                chunkify(EMPTY_STRING, 0);
            }
        );
        assert.throws(
            () => {
                chunkify(EMPTY_STRING, -1);
            }
        );

        //test: fixed valid text input, invalid number of characters
        assert.throws(
            () => {
                chunkify(FIXED_VALID_SMALL_TEST_MESSAGE, 0);
            }
        );
        assert.throws(
            () => {
                chunkify(RANDOM_VALID_SMALL_TEST_MESSAGE, -1);
            }
        );

        //test: random valid text input, invalid number of characters
        assert.throws(
            () => {
                chunkify(RANDOM_VALID_SMALL_TEST_MESSAGE, 0);
            }
        );
        assert.throws(
            () => {
                chunkify(RANDOM_VALID_SMALL_TEST_MESSAGE, Math.floor(((Math.random() - 1) * 10)));
            }
        );
        done();
    });
})