const assert = require('assert');
const {YAMLError} = require("yaml/util");
const {YAMLException} = require("js-yaml");
const getMenuFromFile = require('../../helpers/menuReader').getMenuFromFile;
const Menu = require('../../helpers/menuReader').Menu;

const SAMPLE_MENU = new Menu({
    "Delivery": 100,
    "Menu" : {
        "Butter Naan": {
            price: 200
        },
        "Butter Chicken": {
            price: 600
        }
    },
    Instructions: "Call 87654321 to order!",
    Modifiers: {
        "no ice": 30,
        "regular": 0
    }
})

/**
 * Testing suite for menuReader.js
 * Method signature for getMenuFromFile is (filename)
 */

describe('GetMenuFromFile', function() {
    /**
     * Tests whether valid yml file is parsed correctly.
     */
    it('should output valid menu', function(done) {
        const actualMenu = getMenuFromFile('test/menuReaderTest/testUtil/sampleMenu.yml')
        try {
            assert.deepEqual(actualMenu, SAMPLE_MENU);
            done();
        } catch (e) {
            console.log(e);
            done(e);
        }
    })

    /**
     * Tests whether error is thrown for invalid file name. Error is printed to console.
     */
    it('should throw error with invalid file name', function(done) {
        assert.throws(function () {
            getMenuFromFile('test/testUtil/sampleMen.yml')
        })
        done()
    })

    /**
     * Tests whether getMenuFromFIle throws an error invalid YML. Error is printed to console.
     */
    it('should throw yml parsing error', function(done) {
        assert.throws(function () {
            getMenuFromFile('test/menuReaderTest/testUtil/invalidMenu.yml')
        }, YAMLException)
        done()
    })
})
