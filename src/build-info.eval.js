const package = require('../package.json');

module.exports = {
  name: package.name,
  buildTime: Date.now(),
};