require('./style/index.sss')

if (location.hash) { //Client
  console.log('im Client')
  const url = 'http://localhost:8080' // TODO take from url
  const id = '1' // TODO take from url
  Promise.all([
    import(/*webpackChunkName: "client" */ './Client/Main.elm'),
    import(/* webpackChunkName: "client" */ './connection/client')
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
} else {// Server
  console.log('im Server')
  Promise.all([
    import(/*webpackChunkName: "server" */ './Server/Main.elm'),
    import(/* webpackChunkName: "server" */ './connection/server')
  ])
    .then(function (_) {
      const Elm = _[0]
      const server = _[1]
      // https://www.google.lv/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0ahUKEwifqNGjvtvWAhXIJJoKHZdGAS4QjRwIBw&url=http%3A%2F%2Fwww.vizzed.com%2Fvideogames%2Fcharacter.php%3Fid%3D16064&psig=AOvVaw0XtkTDDvl0N-ScGaTvG3RC&ust=1507360945125240
      const app = Elm.Main.fullscreen({ room: "15#" + "|#6  6 #|# #@# # # # # #".repeat(6) + "|#13 #|15#"})
      const connected = []
      server(5).then(function (peers) {
        console.log(peers)
        peers.forEach(function (peer, index) {
          peer.on('connect', function () {
            app.ports.income.send([index, 0]) // Send to Elm
          })
          peer.on('close', function () {
            console.log("peer disconected, sending to elm")
            app.ports.income.send([index, 1]) // Send to Elm
          })
          peer.on('data', function (data) {
            app.ports.income.send([index, +data]) // Send To Elm
          })
        }
        )
      })
    })
}
