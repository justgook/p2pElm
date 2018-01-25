const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const endpoints = require('./servers/express/endpoints')
const packageData = require('./package.json')
const webpack = require('webpack')
// import * as packageData from './package.json';
// import * as webpack from 'webpack'
// TODO IMPRUVE BY https://medium.com/webpack/unambiguous-webpack-config-with-typescript-8519def2cac7
module.exports = function (env: { waitTime?: Number, fps?: Number, signalingUrl?: String, production: Boolean }) {
  return {
    entry: './src/index.ts',
    output: {
      path: path.resolve(__dirname, 'dist'),
      chunkFilename: '[name].bundle.js',
      filename: 'bundle.js',
    },
    resolve: {
      extensions: ['.ts', '.js']
    },
    module: {
      loaders: [
        {
          test: /\.ts$/,
          use: 'ts-loader',
          exclude: /node_modules/
        },
        {
          test: /\.css$/,
          use: ['style-loader', 'css-loader']
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
              options: {
                maxInstances: 8,
                files: [
                  "src/NewServer/Main.elm",
                  "src/Client/Main.elm"
                ],
                // ...(env && env.production) ? {} : { debug: true, warn: true, forceWatch: true },
              }

            }],
        },
        {
          test: /\.eval\.js$/,
          loader: require.resolve('./scripts/eval-loader.js'),
        },
      ],
    },
    plugins: [
      new webpack.HotModuleReplacementPlugin(),
      new HtmlWebpackPlugin({ title: (env && env.production) ? (<any>packageData).description : `- DEV - ${(<any>packageData).description} ` }),
      new webpack.optimize.ModuleConcatenationPlugin(),
      new webpack.NamedModulesPlugin(),
      new webpack.DefinePlugin({
        WAIT_TIME: JSON.stringify(env && env.waitTime || 60),
        FPS: JSON.stringify(env && env.fps || 30),
        SIGNALING_URL: JSON.stringify(env && env.signalingUrl || `http://localhost:${(<any>packageData).config.port}`)
      }),
    ],
    devServer: {
      // host: '0.0.0.0',
      inline: true,
      stats: 'errors-only',
      contentBase: path.join(__dirname, 'dist'),
      // compress: true,
      port: (<any>packageData).config.port,
      hot: true,
      open: true,
      overlay: true,
      before(app: { use: (endpoint: String, b: Function) => void }) {
        console.log(Object.keys(endpoints))
        Object.keys(endpoints).forEach((key) => app.use(key, endpoints[key]))
      },
    },
  }
}