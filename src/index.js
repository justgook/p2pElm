var intro = require('./entry/intro');
var server = require('./entry/server');
var client = require('./entry/client');
console.log('my inline loader', require('./build-info.eval'));
var container = document.createElement('div');
document.body.appendChild(container);

if (location.hash.substr(0, 6) === '#/join') { //Client
  console.log('Signaling url', SIGNALING_URL)
  const url = 'http://localhost:8080' // TODO take from url
  const id = '1' // TODO take from url
  client(url, id);

} else /* if (location.hash.substr(0, 8) === '#/create') */ {// Server
  server(container);
  // } else {
  //   intro(container, server);
}
