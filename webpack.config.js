const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const webpack = require('webpack')
const endpoints = require('./servers/express/endpoints')
const package = require('./package.json')

module.exports = function (env) {
  return {
    entry: './src/index.js',
    output: {
      path: path.resolve(__dirname, 'dist'),
      chunkFilename: '[name].bundle.js',
      filename: 'bundle.js',
    },
    module: {
      loaders: [
        {
          test: /\.sss$/,
          use: [
            'style-loader',
            "postcss-loader"
          ],
        },
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: [
            {
              loader: 'elm-hot-loader',
            },
            {
              loader: 'elm-webpack-loader',
              options: (env && env.production) ? {} : { debug: true, warn: true, forceWatch: true },
            }],
        },
        {
          test: /\.eval\.js$/,
          loader: require.resolve('./scripts/eval-loader'),
        },
      ],
    },
    plugins: [
      new webpack.HotModuleReplacementPlugin(),
      new HtmlWebpackPlugin({ title: (env && env.production) ? package.description : `- DEV - ${package.description} ` }),
      new webpack.optimize.ModuleConcatenationPlugin(),
      new webpack.DefinePlugin({
        WAIT_TIME: JSON.stringify(env && env.waitTime || 60),
        FPS: JSON.stringify(env && env.fps || 30),
        SIGNALING_URL: JSON.stringify(env && env.signalingUrl || `http://localhost:${package.config.port}`)
      }),
    ],
    devServer: {
      // host: '0.0.0.0',
      contentBase: path.join(__dirname, 'dist'),
      compress: true,
      port: package.config.port,
      hot: true,
      open: true,
      overlay: true,
      setup(app) {
        console.log(Object.keys(endpoints))
        Object.keys(endpoints).forEach((key) => app.use(key, endpoints[key]))
      },
    },
  }
}