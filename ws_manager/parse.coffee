winston = require 'winston'

commandList =
  username: 123
  deviceId: 123
  echo: 1234
  heartBeat: 12345
  login: 21312
  logout: 12312
  register:23423
  
exports.parseCommand = (connection, data, flags)->
  #detect if it's binary
  if flags.binary
    # parse BSON
  else
    # parse JSON
    winston.info 'parsing text JSON'
    try
      data = JSON.parse(data)
      winston.info data
    catch err
      winston.info 'invalid JSON packet'