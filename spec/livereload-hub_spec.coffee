api_version = 1.6
port = 35701


sbscribe = (url, onmessage) ->
  WebSocketClient = require('websocket').client
  client = new WebSocketClient()
  client.on 'connect', (connection) ->
    connection.on 'message', (message) ->
      onmessage(client, message) if onmessage
  client.connect url

reload = (url, ondata) ->
  http = require 'http'
  _url = require('url').parse url
  http.get {
    host: _url.hostname
    port: _url.port || 80
  }, (res) ->
    res.on 'data', (data) ->
      ondata(res, data) if ondata


describe 'LiveReloadHub', ->
  beforeEach ->
    livereload_hub = require('../lib/livereload-hub')
    @server = livereload_hub.createServer()
    @server.setOptions {
      api_version: api_version
    }
    @server.listen port

  describe 'connection', ->
    it 'subscriber', ->
      sbscribe "ws://localhost:#{port}", (client, message) ->
        expect(message.utf8Data).toEqual("!!ver:#{api_version}")
        client.socket.end()
        asyncSpecDone()
      asyncSpecWait()
    
    it 'publisher', ->
      reload "http://localhost:#{port}", (response, data) ->
        expect(data.toString()).toEqual('OK')
        asyncSpecDone()
      asyncSpecWait()

  describe 'reload', ->
    it 'single subscriber', ->
      sbscribe "ws://localhost:#{port}/", (client, message) ->
        if message.utf8Data.match /!!ver/
          reload "http://localhost:#{port}"
        else
          expect(message.utf8Data).toEqual('["refresh",{"path":"/"}]')
          asyncSpecDone()
    
      asyncSpecWait()

    it 'multiple subscriber', ->
      clients = ['localhost', 'localhost']
      count = 0
      for c in clients
        sbscribe "ws://#{c}:#{port}/", (client, message) ->
          unless message.utf8Data.match /!!ver/
            count++

      setTimeout ->
        reload "http://localhost:#{port}"
      , 500

      setTimeout ->
        expect(count).toEqual(clients.length)
        asyncSpecDone()
      , 1000
    
      asyncSpecWait()

    it 'name based virtualhost', ->
      clients = ['localhost', '127.0.0.1']
      count = 0
      for c in clients
        sbscribe "ws://#{c}:#{port}/", (client, message) ->
          unless message.utf8Data.match /!!ver/
            count++

      setTimeout ->
        reload "http://localhost:#{port}"
      , 500

      setTimeout ->
        expect(count).toEqual(1)
        asyncSpecDone()
      , 1000
    
      asyncSpecWait()

  afterEach ->
    @server.close()


jasmine.getEnv().addReporter {
  reportRunnerStarting: (runner) ->
    #
  reportRunnerResults: (runner) ->
    setTimeout ->
      process.exit()
    , 100
  reportSuiteResults: (suite) ->
    #
  reportSpecResults: (spec) ->
    #
}
