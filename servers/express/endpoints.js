const bodyParser = require('body-parser')


function ping(res) {
  res.write(':\n')
}

const PING_INTERVAL = 1000

let servers = {}
const echo = (a) => a
const not = (a) => !a

function countFalse(acc, i) {
  return i ? acc : acc + 1
}
function entriesMapper([id, { taken }]) {
  return {
    id,
    totalSlots: taken.length,
    freeSlots: taken.reduce(countFalse, 0),
    name: "NAME GOES HERE",
  }
}

const cors = require("cors");

const corsOptions = {
  origin: function (origin, callback) {
    callback(null, true);
  },
  credentials: true,
}

module.exports = {
  '*': cors(corsOptions),
  '': bodyParser.json(), //parse post bodies (json)

  '/list'(req, res) {
    res.json(Object.entries(servers).map(entriesMapper))
  },

  '/create-server'(req, res) {
    const offers = req.body
    const offersCount = offers.length
    const id = Date.now()
    servers[id] = { offers, join: null, taken: Array.apply(0, Array(offersCount)).map(() => false) }
    res.json({ id })
    //TODO add expire timeout (read from url or set max) and send that data back to client (for adding countdown - before game starts)
  },
  '/wait-for-players/:id'(req, res) {
    const id = req.params.id
    if (servers[id]) {
      res.writeHead(200, {
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive'
      })
      console.log(`Server(id: ${id}) waits for clients`)

      let uid = 0;
      const event = 'message'
      servers[id].join = (data) => res.write(
        'id:' + (uid++) + '\n' +
        'event:' + (event) + '\n' +
        'data:' + JSON.stringify(data) + '\n'
      )
      servers[id].leave = (index) => {
        servers[id].taken[index] = false
      }
      let t = setInterval(function () {
        ping(res)
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