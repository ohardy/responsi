{print}       = require 'util'
{spawn, exec} = require 'child_process'

runCmd = (cmd, options, callback) ->
  command = spawn cmd, options
  ['stdout', 'stderr'].forEach (elt) ->
    command[elt].on 'data', (data) ->
      print data.toString()

  command.on 'exit', (status) ->
    callback() if callback?

build = (watch, mainCallback) ->
  if typeof watch is 'function'
    callback = watch
    watch = false

  tasks = [
    (callback) ->
      options = ['-c', '-o', 'lib/js', 'src/js']
      options.unshift '-w' if watch
      runCmd './node_modules/.bin/coffee', options, callback
    , (callback) ->
      options = ['-c', '-o', './', 'src/index.coffee']
      options.unshift '-w' if watch
      runCmd './node_modules/.bin/coffee', options, callback
    , (callback) ->
      options = ['-o', 'lib', 'src']
      options.unshift '-w' if watch
      runCmd './node_modules/.bin/stylus', options, callback
    # , (callback) ->
    #   options = ['-P', 'src/views/', '--out', 'lib/templates/']
    #   options.unshift '-w' if watch
    #   runCmd './node_modules/.bin/jade', options, callback
    ]

  if watch
    async = require 'async'
    async.parallel tasks
    mainCallback() if mainCallback?
  else
    for task in tasks
      task()

task 'build', 'Compile CoffeeScript source files', ->
  build false

task 'watch', 'Recompile CoffeeScript source files when modified', ->
  build true
