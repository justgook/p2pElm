declare const WAIT_TIME: number;
declare const FPS: number;

interface Result {
  send(action: number): void;
  restart(room: string): void;
  recive(callback: (data: string[]) => void): void;

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

  console.log("serverPotrts", app.ports)
  return new Promise<Result>(function (resolve, reject) {
    app.ports.serverReady.subscribe(function () {
      resolve({
        send(action) { app.ports.toServer.send([1, action, Date.now()]) },
        recive(callback) { app.ports.toClient.subscribe(callback) },
        restart(room) { app.ports.toServerRestart.send(room) },
      })
    })
  })

}

export { server }