/**
 * Picks characters randomly to form a String of specified length.
 * Taken from https://stackoverflow.com/a/1349426
 *
 * @param length Length of String to be generated.
 * @returns {string} String of length that chooses randomly from given characters.
 */
function randomTextGenerator(length) {
    let result = '';
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789\n\r ';
    const charactersLength = characters.length;
    for (let i = 0; i < length; i++) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
}

exports.randomTextGenerator = randomTextGenerator;