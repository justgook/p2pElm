const Peer = require('simple-peer')

const prepareOffers = function (count: number) {
  return Promise.all(
    Array.apply(0, Array(count)).map(function (_: number, i: number) {
      return new Promise(function (resolve, reject) {
        const peer = new Peer({ initiator: true })
        // create all connections as server (open door for peers)
        peer.on('error', function (err: string) { console.log('error', err) })
        peer.on('connect', function () {
          console.log('CONNECT' + i)
          peer.send('Hello You are #' + i)
        })
        peer.on('close', function () {
          //TODO add some more logic to it, that will free out slot, and some mechanism that will initiati new event, for reconnected
          console.log('Peer #' + i + ' leave')
        })
        // peer.destroy
        peer.on('data', function (data: string) {
          console.log('data(WebRTC)[' + i + ']: ' + data)
        })
        peer.on('signal', function (offer: string) { // generate offers
          resolve({ offer: offer, peer: peer })
        })
      })
    })
  )
}
declare class EventSource {
  constructor(url: string, options?: { withCredentials?: boolean });
  addEventListener(event: string, callback: (e: { data: string }) => void, haveNoClue: boolean): void;
}
function waitForPlayers(peers: any) {
  return function ({ id }: { id: string }) {
    var evtSource = new EventSource('/wait-for-players/' + id, { withCredentials: true })
    evtSource.addEventListener('message', function (e) {
      const data = JSON.parse(e.data)
      console.log('answer', data.answer)
      peers[data.index].signal(data.answer)
    }, false)
  }
}

const establishSignalingServer = function (data: any) {
  //TODO merge two next lines
  const offers = data.map(function (_: { offer: string }) { return _.offer })
  const peers = data.map(function (_: { peer: any }) { return _.peer })
  return fetch('/create-server', {
    credentials: 'include',
    method: 'POST',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(offers)
  })
    .then(function (response) {
      var contentType = response.headers.get('content-type')
      if (contentType && contentType.includes('application/json')) {
        return response.json().then(waitForPlayers(peers))
      }
      throw new TypeError('Oops, we have not got JSON!')
    })
    .catch(function (error) { console.log(error) })
}

//TODO add signalling server url
const connection = function (count: number, manual: boolean) {
  const offers = prepareOffers(count || 1)
  return manual
    ? offers
    : offers.then(function (data) {
      establishSignalingServer(data)
      return data.map(function (_: { peer: any }) { return _.peer })
    })
}

export { connection }