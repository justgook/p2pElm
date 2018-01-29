declare const WAIT_TIME: number;
declare const FPS: number;

interface Result {
  send(action: number): void;
  restart(room: string): void;
  recive(callback: (data: string[]) => void): void;

}


const openConnections = (app: any) => function (peers: any) {
  // console.log(peers)
  peers.forEach(function (peer: any, i: number) {
    const index = i + 1
    // app.ports.server_income.send([index, 1, Date.now()]) // Send to Elm That client is created and disconnected
    peer.on('connect', function () {
      app.ports.server_income.send([index, 0, Date.now()]) // Send to Elm
    })
    app.ports.server_outcome.subscribe((data: any) => {
      if (peer.connected) peer.send(JSON.stringify(data))
    })
    peer.on('close', function () {
      console.log("peer disconected, sending to elm")
      app.ports.server_income.send([index, 1, Date.now()]) // Send to Elm
    })
    peer.on('data', function (data: string) {
      app.ports.server_income.send([index, +data, Date.now()]) // Send To Elm
    })
  }
  )
}

async function server(url: string) {
  const [Elm, { connection }] = await Promise.all([
    import(/*webpackChunkName: "server" */ './NewServer/Main.elm'),
    import(/*webpackChunkName: "server" */ './connection/server')
  ])

  const app = Elm.NewServer.Main.worker({
    waitTime: WAIT_TIME,
    fps: FPS,
  });

  return new Promise<Result>(function (resolve, reject) {
    app.ports.server_ready.subscribe(function () {
      resolve({
        send(action) { app.ports.server_income.send([0, action, Date.now()]) },
        recive(callback) { app.ports.server_outcome.subscribe(callback) },
        restart(room) {
          app.ports.server_start.send(room)
          connection(3, false).then(openConnections(app))
        },
      })
    })
  })

}

export { server }
