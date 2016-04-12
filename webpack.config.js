module.exports = {
  entry: "./lib/sevens.coffee",
  output: {
  	filename: "./lib/bundle.js"
  },
  module: {
  	loaders: [
  		{ test: /\.coffee$/, loader: "coffee-loader" }
  	]
  },
  devtool: 'source-map',
}