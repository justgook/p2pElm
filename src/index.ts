import { setTimeout } from 'timers';

console.log('my inline loader', require('./build-info.eval.js'));
require('./i18n/en.css');
require('./animations.css');


declare const SIGNALING_URL: string;


async function startServer(app: any, url: string) {
  /* ----------------------------------------------------------------*/
  const { server } = await import(/*webpackChunkName: "server" */ './server')
  const { send, recive, restart } = await server(url);
  app.ports.client_outcome.subscribe(send); //send client Actions to server
  recive(app.ports.client_income.send) //recive Updates from server
  restart('15#' + '|#4 b $3 3 #|# #@  # # # # #'.repeat(6) + '|#13 #|15#')
  setTimeout(() => send(0), 0) // NEED TIMEOUT to wait until server model updates
  /* ----------------------------------------------------------------*/
}


(async function clientEntry(url: string) {

  const [Elm, { default: join2server }] = await Promise.all([
    import(/*webpackChunkName: "client" */ './Client/Main.elm'),
    import(/*webpackChunkName: "client" */ './connection/client')
  ])

  const app = Elm.Client.Main.fullscreen()
  app.ports.client_serverListRequest.subscribe(async function () {
    const response: any = await fetch(`${url}/list`)
    app.ports.client_serverListResponse.send(await response.json())
  })

  app.ports.client_create.subscribe(async function (name: string) {
    startServer(app, url);
    console.log(`request level creation with name ${name}`)

  })

  app.ports.client_join.subscribe(function (id: string) {
    join2server(url, id).then(function (serverConnection: any) {
      serverConnection.on('data', function (data: any) {
        app.ports.client_income.send(JSON.parse(data + ""))
      })
      app.ports.client_outcome.subscribe((a: number) => serverConnection.send(a))
    })
  })
  /* Delme!!!! */
  // startServer(app, url);

})(SIGNALING_URL);



// declare const Stats: any;
// (function () {
//   var script = document.createElement('script');
//   script.onload = function () {

//     var stats = new Stats();
//     // stats.showPanel(2);
//     document.body.appendChild(stats.dom);
//     requestAnimationFrame(function loop() {
//       stats.update();
//       requestAnimationFrame(loop)
//     });
//   };
//   script.src = '//rawgit.com/mrdoob/stats.js/master/build/stats.min.js';
//   document.head.appendChild(script);
// })();