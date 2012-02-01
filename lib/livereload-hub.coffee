http      = require "http"
websocket = require "websocket"
crypto    = require "crypto"


class LivereloadHub

  constructor: (callback) ->
    @api_version   = '1.6'
    @clients       = {}
    @host_matching = true
    @http_callback = callback || this._httpCallback

    @logger = require('logger').createLogger()
    @logger.setLevel('warn')


  setOptions: (opts) ->
    for key, value of opts
      this[key] = value if value?


  listen: (port) ->
    server = http.createServer this.http_callback
    server.listen port, =>
      @logger.info "Server is listening on port #{port}"

    WebSocketServer = websocket.server
    wsServer = new WebSocketServer(
      httpServer: server
      autoAcceptConnections: false
    )

    wsServer.on "request", (request) =>
      key = crypto.createHash('sha1').update(Math.random()+'').digest('hex')

      connection = request.accept()
      @logger.info "Connection accepted."
      connection.sendUTF "!!ver:#{@api_version}"

      @clients[key] = {
        connection: connection
        request: request
      }

      connection.on "message", (message) =>
        if message.type is "utf8"
          @logger.info "Received Message: " + message.utf8Data
        else if message.type is "binary"
          @logger.info "Received Binary Message of " + message.binaryData.length + " bytes"

      connection.on "close", (reasonCode, description) =>
        delete @clients[key]
        @logger.info "Peer " + connection.remoteAddress + " disconnected."


  _httpCallback: (request, response) =>
    @logger.info "Received request for " + request.url

    message = JSON.stringify [ "refresh",
      path: request.url
    ]
    @logger.info message
    for key, c of @clients
      continue if @host_matching && c.request.host != request.headers.host
      c.connection.sendUTF message

    response.writeHead 200
    response.write 'OK'
    response.end()


@LivereloadHub = exports =
  version: '0.1.0'
  createServer: (callback) ->
    new LivereloadHub callback

module.exports = exports  if module?
