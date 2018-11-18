// webpack.config.js
// Configure CSS processing & injection
const webpack = require('webpack');
const path = require('path');
const glob = require('glob-all');
const ExtractTextPlugin = require('extract-text-webpack-plugin')


module.exports = {
  entry: {
    index: './source/javascripts/site.js',
    reactSearch: './source/javascripts/reactSearch.js',
  },
  output: {
    path: __dirname + '/.tmp/dist',
    filename: '[name].js',
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: [
           "babel-loader",  
        ]
      },
      {
        test: /\.css$/,
        use: [
          'style-loader',
          'css-loader',
        ]
      },
      // image Handling
      {
        test: /\.(jpe?g|png|gif|svg)$/i,
        loaders: [
          'file-loader?hash=sha512&digest=hex&name=[hash].[ext]',
        ],
      },
      {
        test: /\.scss$|.sass$/,
        loader: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: [
            'css-loader',
            'sass-loader'
          ],
        }),
      },
    ]
  },
  plugins: [
    new ExtractTextPlugin('[name].[contenthash].css')
  ]
}