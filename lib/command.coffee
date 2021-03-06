runner = ->
  livereload_hub = require('./livereload-hub')

  opts = require "opts"
  opts.parse [
    {
      short: 'p'
      long: 'port'
      description: 'port'
      value: true
      required: false
    }
    {
      short: 'a'
      long: 'api-version'
      description: 'API version'
      value: true
      required: false
    }
    {
      long: 'log-level'
      description: 'Log level'
      value: true
      required: false
    }
    {
      long: 'log-file'
      description: 'Log file'
      value: true
      required: false
    }
    {
      long: 'disable-host-header-matching'
      description: "Disable host header matching\n(Use this option when you don't use name based virtual host)"
      required: false
    }
  ].reverse(), true

  port          = opts.get('port') || 35729
  api_version   = opts.get('api-version')
  log_level     = opts.get('log-level') || 'warn'
  log_file      = opts.get('log-file') || null
  host_matching = ! opts.get('disable-host-header-matching')

  logger = require('logger').createLogger(log_file)
  logger.setLevel(log_level)

  server = livereload_hub.createServer()
  server.setOptions(
      api_version: api_version
      debug_level: (verbose ? 1 : 0)
      logger: logger
      host_matching: host_matching
  )
  server.listen port


module.exports =
  run: runner
