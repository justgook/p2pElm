module.exports = function (url, id) {
  require('../style/index.sss')
  console.log('im Client')
  Promise.all([
    import(/*webpackChunkName: "client" */ '../Client/Main.elm'),
    import(/*webpackChunkName: "client" */ '../connection/client')
  ])
    .then(function (_) {
      const Elm = _[0]
      const client = _[1]
      const app = Elm.Main.fullscreen();
      client(url, id).then(function (ServerPeer) {
        console.log(ServerPeer)
        console.log('CONECTED TO SERVER!!!')
        ServerPeer.on('data', function (data) {
          console.log('data from server: ' + data)
        })
        app.ports.did.subscribe(function (a) {
          ServerPeer.send(a)
        });
      })
    })
}