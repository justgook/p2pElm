const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const endpoints = require('./servers/express/endpoints')
const packageData = require('./package.json')
const webpack = require('webpack')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const FaviconsWebpackPlugin = require('favicons-webpack-plugin')
const MetaPlugin = require('./webpackPlugin/MetaPlugin')

const uglifyJSOptions = {
  sequences: true, // join consecutive statemets with the "comma operator"
  properties: true, // optimize property access: a["foo"] → a.foo
  dead_code: true, // discard unreachable code
  drop_debugger: true, // discard "debugger" statements
  drop_console: true,
  unsafe: false, // some unsafe optimizations (see below)
  conditionals: true, // optimize if-s and conditional expressions
  comparisons: true, // optimize comparisons
  evaluate: true, // evaluate constant expressions
  booleans: true, // optimize boolean expressions
  loops: true, // optimize loops
  unused: true, // drop unused variables/functions
  hoist_funs: true, // hoist function declarations
  hoist_vars: false, // hoist variable declarations
  if_return: true, // optimize if-s followed by return/continue
  join_vars: true, // join var declarations
  side_effects: true, // drop side-effect-free statements
  warnings: true, // warn about potentially dangerous optimizations/code
  global_defs: {}, // global definitions
};

module.exports = function (env: { waitTime?: Number, fps?: Number, signalingUrl?: String, production: Boolean }) {
  return {
    entry: './src/index.ts',
    output: {
      path: path.resolve(__dirname, 'dist'),
      // publicPath: "/src/",
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
      (env && env.production)
        ? new UglifyJsPlugin({
          parallel: 8,
          uglifyOptions: {
            ie8: false,
            ecma: 5,
            compress: uglifyJSOptions,
          }
        })
        : new webpack.HotModuleReplacementPlugin(),
      new HtmlWebpackPlugin({
        title: (env && env.production)
          ? (<any>packageData).description
          : `- DEV - ${(<any>packageData).description}`,
        hash: (env && env.production)
      }),
      new FaviconsWebpackPlugin({
        inject: true,
        background: '#020307',
        // Your source logo
        logo: './src/assets/icon.png',
        // The prefix for all image files (might be a folder or a name)
        prefix: 'icons-[hash]/',
        // Emit all stats of the generated icons
        emitStats: true,
        // Generate a cache file with control hashes and
        // don't rebuild the favicons until those hashes change
        persistentCache: true,
      }),
      new webpack.optimize.ModuleConcatenationPlugin(),
      new webpack.NamedModulesPlugin(),
      new webpack.DefinePlugin({
        WAIT_TIME: JSON.stringify(env && env.waitTime || 60),
        FPS: JSON.stringify(env && env.fps || 30),
        SIGNALING_URL: JSON.stringify(env && env.signalingUrl || `http://localhost:${(<any>packageData).config.port}`)
      }),
      new CopyWebpackPlugin([
        // {output}/file.txt
        { from: 'src/assets/preview.png', to: "preview.png" },
      ]),
      new MetaPlugin(
        (({ url, image, title, description }) => ({
          facebook: {
            type: "website",
            url,
            title,
            description,
            image: url + image,
            image_width: 500,
            image_height: 500
          },
          twitter: {
            card: "summary_large_image",
            domain: "justgook.github.io",
            title,
            description,
            image: url + image,
            url,
            label1: "Version",
            data1: (<any>packageData).version,
            label2: "License",
            data2: (<any>packageData).license
          }
        }))({
          url: `https://justgook.github.io/p2pElm/`,
          image: "preview.png",
          title: "Bitmap Font Builder",
          description: (<any>packageData).description
        })
      ),
    ],
    devServer: {
      host: '0.0.0.0',
      inline: true,
      stats: 'errors-only',
      contentBase: path.join(__dirname, 'dist'),
      // compress: true,
      port: (<any>packageData).config.port,
      hot: true,
      open: true,
      overlay: true,
      before(app: any) {
        console.log(Object.keys(endpoints))
        app.all('*', function (req: any, res: any, next: any) {
          res.header("Access-Control-Allow-Origin", "*");
          res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
          next();
        });
        Object.keys(endpoints).forEach((key) => app.use(key, endpoints[key]))

      },
    },
  }
}