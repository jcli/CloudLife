
events = require('events')
EventEmitter = events.EventEmitter


class exports.Connections 
  constructor: ->
    @masterList = {}
  toString : =>
    for key, value of @masterList
      console.log "key: " + key + " value: " + value
  deleteConnection : (key, code, message)=>
#    delete the connections
    delete @masterList[key]

  
class exports.Connection extends EventEmitter
  @creationCount = 0
  constructor: (@ws, @connections)->
    @id = Connection.creationCount+=1;
    @ws.on('message', (data, flag)=>
      console.log data, flag, 'id: ', @id
      @ws.send data
    )
    @ws.on('close', (code, message)=>
      @emit('deleteConnection', @id, code, message)
    )
    @.on('deleteConnection', @connections.deleteConnection)
  toString: =>
    return "connection_object_id_"+@id