// One of posible solutions for little server
// https://runkit.com/home
// https://www.redhat.com/
// https://www.heroku.com/
// https://zeit.co/now
// https://www.quora.com/What-are-alternatives-to-pusher-com

const endpoints = require('./endpoints')
const package = require('../../package.json')

const express = require('express')
const app = express()

Object.keys(endpoints).forEach((key) => app.use(key, endpoints[key]))
app.all('*', function (req, res, next) {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Credentials', true);
  res.header('Access-Control-Allow-Methods', 'PUT, GET, POST, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next();
});
app.listen(package.config.port, function () {
  console.log(`--${package.description}-- WebRTC signaling server starts on ${package.config.port}`)
})