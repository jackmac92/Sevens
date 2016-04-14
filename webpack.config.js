module.exports = {
  entry: "./js/sevens.coffee",
  output: {
  	filename: "./js/bundle.js"
  },
  module: {
  	loaders: [
  		{ test: /\.coffee$/, loader: "coffee-loader" }
  	]
  },
  devtool: 'source-map',
}