const queries = require('./db/queries');
queries.clearOldEntries('miscellaneous', 'helper');
queries.clearOldEntries('miscellaneous', 'cache');