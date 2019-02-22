const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = (env, options) => ({
  optimization: {
    minimizer: [
      new UglifyJsPlugin({ cache: true, parallel: true, sourceMap: false }),
      new OptimizeCSSAssetsPlugin({})
    ]
  },

  entry: {
    './js/app.js': ['./js/app.jsx'].concat(glob.sync('./vendor/**/*.js'))
  },

  output: {
    filename: 'app.js',
    path: path.resolve(__dirname, '../priv/static/js')
  },

  module: {
    rules: [
      {
        test: /\.(jsx|js)$/, exclude: /node_modules/, use: {
          loader: 'babel-loader',
          options: { babelrc: true }
        }
      },
      {test: /\.css$/, use: [MiniCssExtractPlugin.loader, 'css-loader']}
    ]
  },

  resolve: {
    alias: {
      js: path.resolve(__dirname, 'js'),
      components: path.resolve(__dirname, 'js/components'),
      remote_routes: path.resolve(__dirname, 'js/remote_routes'),
      local_routes: path.resolve(__dirname, 'js/local_routes'),
      errors: path.resolve(__dirname, 'js/components/errors'),
      routes: path.resolve(__dirname, 'js/components/routes'),
      utils: path.resolve(__dirname, 'js/utils')
    },
    extensions: ['.js', '.json', '.jsx']
  },

  plugins: [
    new MiniCssExtractPlugin({ filename: '../css/app.css' }),
    new CopyWebpackPlugin([{ from: 'static/', to: '../' }])
  ]
});
