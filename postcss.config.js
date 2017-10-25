module.exports = ({ file, options, env }) => {
  console.log(`!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${file.extname}!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!`)
  console.log(file, options, env)
  return {
    parser: 'sugarss',
    plugins: {
      'postcss-import': { root: file.dirname },
      'postcss-calc': {},
      'postcss-for': {},
      'postcss-cssnext': options.cssnext ? options.cssnext : false,
      'autoprefixer': env === 'production' ? options.autoprefixer : false,
      'cssnano': env === 'production' ? options.cssnano : false
    }
  }
}
