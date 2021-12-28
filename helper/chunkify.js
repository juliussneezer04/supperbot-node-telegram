function chunkify(message, maxChars){
    if (maxChars < 1){
        throw "Invalid input, number of characters must be greater than zero.";
    }

    let chunks = [];

    if (message.length <= maxChars){
        chunks.push(message);
        return chunks;
    }

    const firstSection = message.slice(0, maxChars);

    const nextLineIdx = firstSection.lastIndexOf('\n');
    const carriageIdx = firstSection.lastIndexOf('\r');
    const breakIdx = Math.max(nextLineIdx, carriageIdx); //the last occurrence of carriage return and newline

    let currLine = '', remainder = '', splitIdx = 0;

    if (breakIdx >= 0){
        splitIdx = breakIdx + 1;
    } else { //no line break found
        const whitespaceIdx = firstSection.lastIndexOf(' ');
        if (whitespaceIdx >= 0){
            splitIdx = whitespaceIdx + 1;
        } else {
            splitIdx = maxChars; //includes maxChars in chunk
        }
    }

    currLine = message.slice(0, splitIdx);
    remainder = message.slice(splitIdx);
    chunks.push(currLine);

    const subChunk = chunkify(remainder, maxChars);
    for (let i = 0; i < subChunk.length; ++i){
        chunks.push(subChunk[i]);
    }
    return chunks;
}

exports.chunkify = chunkify;