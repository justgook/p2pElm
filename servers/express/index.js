// One of posible solutions for little server
// https://runkit.com/home
// https://www.redhat.com/
// https://www.heroku.com/
// https://zeit.co/now

const endpoints = require('./endpoints')
const package = require('../../package.json')


const express = require('express')
const app = express()

Object.keys(endpoints).forEach((key) => app.use(key, endpoints[key]))

app.listen(package.config.port, function () {
  console.log(`--${package.description}-- WebRTC signaling server starts on ${package.config.port}`)
})