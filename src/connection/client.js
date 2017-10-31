const Peer = require('simple-peer')
const getOffer = function (serverId, url) {
  return fetch(url + '/join/' + serverId, { // TODO move to env variable or some custom setting field
    credentials: 'include',
    method: 'GET',
    headers: {
      'Accept': 'application/json',
      // 'Content-Type': 'application/json'
    },
    // body: JSON.stringify(offers)
  })
    .then(function (response) {
      var contentType = response.headers.get('content-type')
      if (contentType && contentType.includes('application/json')) {
        return response.json()
      }
      throw new TypeError('Oops, we have not got JSON!')
    })
    .catch(function (error) { console.log(error) })
}

function sendAnswer(serverId, index, url) {
  return function (answer) { // TODO get rid of those functions that returns functions Grr
    return fetch(url + '/answer/' + serverId + '/' + index, { // TODO move to env variable or some custom setting field
      credentials: 'include',
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(answer)
    })
  }
}

function connectToServer(serverId, url) {
  return function how(args) {// TODO get rid of those functions that returns functions Grr
    const p = new Peer({ /*, trickle: false*/ }) //TODO what for trickle?
    const answer = new Promise(function (resolve, reject) {
      p.on('signal', function (data) { //TODO findout why ther is {candidate} signals (what for)
        // if(data.candidate)
        resolve(data)
      })
      p.signal(args.offer)
    }).then(sendAnswer(serverId, args.index, url))// TODO get rid of those functions that returns functions Grr
    return new Promise(function (resolve, reject) {
      p.on('connect', function () {
        resolve(p)
      })
    })
  }

}
module.exports = function (url, id) {
  return getOffer(id, url)
    .then(connectToServer(id, url)) // TODO get rid of those functions that returns functions Grr
}