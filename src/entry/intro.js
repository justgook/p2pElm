module.exports = function (container, server) {
  import(/*webpackChunkName: "intro" */ '../Intro/Main.elm')
    .then(function (Elm) {
      require('../style/intro.sss'); // Make that Async
      console.log(Elm)
      const app = Elm.Main.embed(container);
      app.ports.startServert.subscribe(function(){
        window.location.href = "/#/create";
        location.reload();
        // TODO update to some nice way, how to remount Elm 0.19 app
        // app.dispose();
        // server();
      })
    })
}