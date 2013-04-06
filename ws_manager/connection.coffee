events = require 'events'
EventEmitter = events.EventEmitter
Parse = require './parse'
winston = require 'winston'

class exports.Connections 
  constructor: ->
    @masterList = {}
  toString : =>
    for key, value of @masterList
      console.log "key: " + key + " value: " + value
  deleteConnection : (key, code, message)=>
    delete @masterList[key]
    winston.info @constructor.name + ': deleted connection ' + key
    
class exports.Connection extends EventEmitter
  @creationCount = 0
  constructor: (@ws, @connections)->
    @id = Connection.creationCount+=1;
    @ws.on('message', (data, flags)=>
      @emit('dataReceived', @, data, flags)
    )
    @ws.on('close', (code, message)=>
      @emit('deleteConnection', @id, code, message)
    )
    @.on('deleteConnection', @connections.deleteConnection)
    @.on('dataReceived', Parse.parseCommand)
  toString: =>
    return "connection_object_id_"+@id