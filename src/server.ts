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

  return new Promise<Result>(function (resolve, reject) {
    app.ports.server_ready.subscribe(function () {
      resolve({
        send(action) { app.ports.server_income.send([0, action, Date.now()]) },
        recive(callback) { app.ports.server_outcome.subscribe(callback) },
        restart(room) { app.ports.server_start.send(room) },
      })
    })
  })

}

export { server }
