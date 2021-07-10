const { environment } = require('@rails/webpacker')

environment.plugins.append("Provide", new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popperjs', 'default']
}))

module.exports = environment
