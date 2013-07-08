stylus = require 'stylus'
nodes  = stylus.nodes
utils  = stylus.utils
path   = require 'path'

exports = module.exports = plugin = ->
  (style) ->
    style.include exports.path

    # if (Canvas) {
    #   style.define('has-canvas', nodes.true);

    #   // gradients
    #   style.define('create-gradient-image', gradient.create)
    #   style.define('gradient-data-uri', gradient.dataURL)
    #   style.define('add-color-stop', gradient.addColorStop)

    #   // color images
    #   style.define('create-color-image', colorImage.create)
    #   style.define('color-data-uri', colorImage.dataURL);
    # else
    #   style.define('has-canvas', nodes.false);

exports.version = '0.1'
exports.path    = path.join __dirname, 'src'
