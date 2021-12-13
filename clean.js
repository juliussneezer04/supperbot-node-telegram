const queries = require("./db/queries");

queries.clearOldEntries('jiodata', 'jios');
queries.clearOldEntries('miscellaneous', 'helper');
queries.clearOldEntries('miscellaneous', 'cache');