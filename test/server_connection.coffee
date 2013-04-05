vows = require 'vows'
assert = require 'assert'
host = 'localhost'
port = 3000
vows.describe('testin the server connections').addBatch
  'when requesting the webserver':
    topic: ->
      http = require 'http'
      options =
        host: host,
        port: port,
        path: '/'
      callback = @callback
      http.get(options,(res)->
        callback null, res
      ).on('error', (e)->
        callback e, null
      )
      return      
    'should equal to 200': (e, res)->
      assert.isNull e
      assert.equal res.statusCode, 200
  'when openning a websocket to the server':
    topic: ->
      WebSocket = require '../node_modules/ws'
      ws = new WebSocket 'ws://'+host+':'+port
      callback = @callback
      ws.on 'open', ->
        ws.close()
      ws.on 'close', ->
        callback null, true
      ws.on 'error', (error)->
        callback error, false
      return
    'should not have error':(e, res)->
      assert.isNull(e)
.export(module)