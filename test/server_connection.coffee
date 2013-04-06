vows = require 'vows'
assert = require 'assert'
host = 'localhost'
port = 3000
testMsg = 'this is a  test'
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
      echoMsg = ''
      count = 0
      ws.on 'open', ->
        ws.send testMsg
      ws.on 'message', (data, flag)->
        echoMsg = data
        ws.close()
      ws.on 'close', ->        
        callback null, echoMsg
      ws.on 'error', (error)->
        callback error, false
      return
    'should not have error':(e, res)->
      assert.isNull(e)
    'should equal to :' : (e, res)->
      assert.equal(res, testMsg)
.export(module)