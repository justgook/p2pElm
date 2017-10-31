const bodyParser = require('body-parser')


function ping(res) {
  res.write(':\n')
}

const PING_INTERVAL = 1000

let servers = {}
const echo = (a) => a
const not = (a) => !a

module.exports = { //TODO find better api and make it cleanner
  '': bodyParser.json(), //parse post bodies (json)
  '/create-server'(req, res) { //TODO move url to Env variables

    const offers = req.body
    const offersCount = offers.length
    const id = 1 // TODO update to real id!!
    // const id = Date.now()
    servers[id] = { offers, join: null, taken: Array.apply(0, Array(offersCount)).map(() => false) } //TODO update join to some buffer function / or error response
    console.log(`Server(id: ${id}) created with ${offersCount} slots`)
    res.json({ id })
    //TODO add expire timeout (read from url or set max) and send that data back to client (for adding countdown - before game starts)
  },
  '/wait-for-players/:id'(req, res) { //TODO move url to Env variables
    const id = req.params.id
    if (servers[id]) {
      res.writeHead(200, {
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive'
      })
      console.log(`Server(id: ${id}) waits for clients`)
      let uid = -1
      const event = 'message'
      // const data = 'test data'
      servers[id].join = (data) => res.write(
        'id:' + (++uid) + '\n' +
        'event:' + (event) + '\n' +
        'data:' + JSON.stringify(data) + '\n'
      )
      servers[id].leave = (index) => {
        servers[id].taken[index] = false
      }
      let t = setInterval(function () {
        ping(res)
        // console.log(`Send Ping to Server(id: ${id})`)
        res.write('\n\n')
        res.flush()
      }, PING_INTERVAL)
      res.socket.on('close', function () {
        console.log(`Server(id: ${id}) close`)
        delete servers[id]
        clearInterval(t)
      })
    } else {
      res.json({ error: `Server(id: ${id}) not registred` })
    }
  },
  '/join/:id'(req, res) {
    const id = req.params.id
    if (servers[id]) {
      const index = servers[id].taken.findIndex(not) // find first untaken slot
      servers[id].taken[index] = true
      res.json({ index, offer: servers[id].offers[index] })
    } else {
      res.json({ error: `Server(id: ${id}) not registred` })
    }
  },
  '/answer/:id/:index'(req, res) {
    const { id, index } = req.params
    const answer = req.body
    servers[id].join({ index, answer })
    res.json({ staus: 'ok' })
  }
}