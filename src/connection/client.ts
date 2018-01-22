// import { SimplePeer } from 'simple-peer'
import * as Peer from 'simple-peer'

const getOffer = function (serverId: string, url: string) {
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

function sendAnswer(serverId: string, index: string, url: string) {
  return function (answer: string) { // TODO get rid of those functions that returns functions Grr
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

interface SignalData {
  sdp?: any;
  candidate?: any;
}
declare class SimplePeer {
  constructor(a?: { trickle?: boolean });
  on(event: string, done: (data: string | SignalData) => void): void;
  signal(data: string | SignalData): void;
}

function connectToServer(serverId: string, url: string) {
  return function how(args: { offer: string, index: string }) {// TODO get rid of those functions that returns functions Grr
    const p: SimplePeer = new Peer({ /*, trickle: false*/ }) //TODO what for trickle?
    const answer = new Promise(function (resolve, reject) {
      p.on('signal', function (data: string) { //TODO findout why ther is {candidate} signals (what for)
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

export default function (url: string, id: string) {
  return getOffer(id, url)
    .then(connectToServer(id, url)) // TODO get rid of those functions that returns functions Grr
}