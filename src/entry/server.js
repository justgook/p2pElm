function requestServer(app) { //TODO move outside
  return function (c) {
    import(/* webpackChunkName: "server" */ '../connection/server').then(function (server) {
      server(c).then(function (peers) {
        // console.log(peers)
        peers.forEach(function (peer, index) {
          app.ports.income.send([index, 1, Date.now()]) // Send to Elm That client is created and disconnected
          peer.on('connect', function () {
            app.ports.income.send([index, 0, Date.now()]) // Send to Elm
          })
          peer.on('close', function () {
            console.log("peer disconected, sending to elm")
            app.ports.income.send([index, 1, Date.now()]) // Send to Elm
          })
          peer.on('data', function (data) {
            app.ports.income.send([index, +data, Date.now()]) // Send To Elm
          })
        }
        )
      })
    })
  }
}

module.exports = function (container) {
  require('../style/index.sss') // TODO change to real one
  console.log('im Server')
  import(/*webpackChunkName: "server" */ '../Server/Main.elm')
    .then(function (Elm) {
      // https://www.google.lv/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0ahUKEwifqNGjvtvWAhXIJJoKHZdGAS4QjRwIBw&url=http%3A%2F%2Fwww.vizzed.com%2Fvideogames%2Fcharacter.php%3Fid%3D16064&psig=AOvVaw0XtkTDDvl0N-ScGaTvG3RC&ust=1507360945125240
      //TODO UPGRADE TO WORKER!!! http://package.elm-lang.org/packages/elm-lang/core/latest/Platform - Elm.Main.worker(...)
      console.log(Elm.Main.worker)
      const app = Elm.Main.fullscreen({
        rooms: [
          '4#|#@ #|# @#|4#',
          '15#' + '|#4 b $3 3 #|# #@  # # # # #'.repeat(6) + '|#13 #|15#'
        ],
        waitTime: WAIT_TIME,
        fps: FPS,
      })
      const connected = []
      app.ports.requestServer.subscribe(requestServer(app));
    })

}
