const path = require('path')
const glob = require('glob')
const TerserPlugin = require('terser-webpack-plugin')
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const { VueLoaderPlugin } = require('vue-loader')

const production = process.env.NODE_ENV === 'production'
const filename = production ? '[name]-[hash]' : '[name]'

module.exports = (env, options) => ({
  optimization: {
    minimize: options.mode === 'production' || production,
    minimizer: [new TerserPlugin({}), new OptimizeCSSAssetsPlugin({})],
  },
  entry: {
    'js/app': path.resolve(__dirname, './js/app.js'),
  },
  output: {
    filename: `${filename}.js`,
    path: path.resolve(__dirname, '../priv/static'),
  },
  resolve: {
    alias: {
      // Same as tsconfig.json
      '@': path.join(__dirname, './js'),
      '~': path.join(__dirname, './'),
      vue$: 'vue/dist/vue.esm.js',
    },
    extensions: ['.ts', '.js', '.vue', '.json', '.css', '.node'],
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: ['babel-loader'],
      },
      {
        test: /\.vue?$/,
        use: [
          {
            loader: 'vue-loader',
            options: {
              esModule: true,
              optimizeSSR: false,
            },
          },
        ],
      },
      {
        test: /\.scss$/,
        use: [
          'vue-style-loader',
          {
            loader: 'css-loader',
            options: {
              esModule: false,
            },
          },
          'sass-loader',
        ],
      },
      {
        test: /\.css$/,
        use: [
          'vue-style-loader',
          'style-loader',
          {
            loader: 'css-loader',
            options: {
              esModule: false,
            },
          },
          'sass-loader',
        ],
      },
      {
        test: /\.(woff2?|eot|ttf|otf)(\?.*)?$/,
        use: {
          loader: 'url-loader',
          query: {
            limit: 10000,
            name: '/fonts/[name]--[folder].[ext]',
          },
        },
      },
      {
        test: /\.svg(\?v=\d+\.\d+\.\d+)?$/,
        use: 'url-loader?limit=10000&mimetype=image/svg+xml',
      },
      {
        test: /\.(jpg|jpeg|png)$/,
        use: 'url-loader',
      },
    ],
  },
  plugins: [
    new VueLoaderPlugin(),
    new CopyWebpackPlugin({
      patterns: [
        {
          from: path.join(__dirname, './static'),
          to: path.join(__dirname, '../priv/static'),
        },
      ],
    }),
  ],
})
