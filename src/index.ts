console.log('my inline loader', require('./build-info.eval.js'));
require('./i18n/en.css');


declare const SIGNALING_URL: string;


(async function clientEntry(url: string) {

  const [Elm, { default: join2server }] = await Promise.all([
    import(/*webpackChunkName: "client" */ './Client/Main.elm'),
    import(/*webpackChunkName: "client" */ './connection/client')
  ])

  const app = Elm.Client.Main.fullscreen()
  console.log("ClientPotrts", app.ports)
  app.ports.serverListRequest.subscribe(async function () {
    const response: any = await fetch(`${url}/list`)
    app.ports.serverListResponse.send(await response.json())
  })

  app.ports.create.subscribe(async function (name: string) {
    const server = await import(/*webpackChunkName: "server" */ './server')
    console.log(`request level creation with name ${name}`)
  })

  app.ports.join.subscribe(function (id: string) {
    join2server(url, id).then(function (serverConnection: any) {
      serverConnection.on('data', function (data: any) {
        console.log('data from server: ' + data)
      })
      app.ports.clientAction.subscribe(serverConnection.send)
    })
  })

  /* ----------------------------------------------------------------*/
  const { server } = await import(/*webpackChunkName: "server" */ './server')
  const { send, recive, restart } = await server(SIGNALING_URL);
  app.ports.clientAction.subscribe(send); //send client Actions to server
  recive(app.ports.levelUpdate) //recive Updates from server
  restart('15#' + '|#4 b $3 3 #|# #@  # # # # #'.repeat(6) + '|#13 #|15#')
  /* ----------------------------------------------------------------*/

})(SIGNALING_URL)