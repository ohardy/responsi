// Generated by CoffeeScript 1.6.3
(function() {
  var exports, nodes, path, plugin, stylus, utils;

  stylus = require('stylus');

  nodes = stylus.nodes;

  utils = stylus.utils;

  path = require('path');

  exports = module.exports = plugin = function() {
    return function(style) {
      return style.include(exports.path);
    };
  };

  exports.version = '0.1';

  exports.path = path.join(__dirname, 'src');

}).call(this);
