console.log('my inline loader', require('./build-info.eval.js'));
require('./i18n/en.css');


declare const SIGNALING_URL: string;



(async function clientEntry(url: string) {

  const [Elm, { default: join2server }] = await Promise.all([
    import(/*webpackChunkName: "client" */ './Client/Main.elm'),
    import(/*webpackChunkName: "client" */ './connection/client')
  ])

  const app = Elm.Client.Main.fullscreen()
  app.ports.client_serverListRequest.subscribe(async function () {
    const response: any = await fetch(`${url}/list`)
    // app.ports.client_serverListResponse.send(await response.json())
  })

  app.ports.client_create.subscribe(async function (name: string) {
    const server = await import(/*webpackChunkName: "server" */ './server')
    console.log(`request level creation with name ${name}`)
  })

  app.ports.client_join.subscribe(function (id: string) {
    join2server(url, id).then(function (serverConnection: any) {
      serverConnection.on('data', function (data: any) {
        console.log('data from server: ' + data)
      })
      app.ports.client_outcome.subscribe(serverConnection.send)
    })
  })

  /* ----------------------------------------------------------------*/
  const { server } = await import(/*webpackChunkName: "server" */ './server')
  const { send, recive, restart } = await server(SIGNALING_URL);
  app.ports.client_outcome.subscribe(send); //send client Actions to server
  recive(app.ports.client_income.send) //recive Updates from server
  // restart(' | @ | ')
  restart('15#' + '|#4 b $3 3 #|# #@  # # # # #'.repeat(6) + '|#13 #|15#')
  send(0)
  /* ----------------------------------------------------------------*/

})(SIGNALING_URL);



declare const Stats: any;
(function () {
  var script = document.createElement('script');
  script.onload = function () {

    var stats: any = new Stats();
    // stats.showPanel(2);
    document.body.appendChild(stats.dom);
    requestAnimationFrame(function loop() {
      stats.update();
      requestAnimationFrame(loop)
    });
  };
  script.src = '//rawgit.com/mrdoob/stats.js/master/build/stats.min.js';
  document.head.appendChild(script);
})();