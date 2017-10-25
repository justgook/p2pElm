var { defineSupportCode } = require('cucumber')

const express = require('express')

const endpoints = require('../../../servers/express/endpoints')
const package = require('../../../package.json')
let app = null
let server = null

const startServer = function () {
  let app = express()
  Object.keys(endpoints).forEach((key) => app.use(key, endpoints[key]))
  app.use(express.static('dist'))
  return new Promise(function (resolve, _){
    server = app.listen(package.config.port, function () {
      console.log(`--${package.description}-- WebRTC signaling server starts on ${package.config.port}`)
      resolve()
    })
  })
}

defineSupportCode(function ({ Given, When, Then, After }) {
  Given(/^Running WebRTC signaling server$/, startServer)

  After(function () {
    return server && server.close()
  })
})

