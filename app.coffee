
# module dependencies
#

express = require 'express'
routes  = require './routes'
user    = require './routes/user'
https   = require 'https'
http    = require 'http'
path    = require 'path'
fs      = require 'fs'

app = express()

app.configure(
   ->
    app.set('port', process.env.PORT || 3000)
    app.set('views', __dirname + '/views')
    app.set('view engine', 'jade');
    app.use(express.favicon());
    app.use(express.logger('dev'));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
    app.use(express.static(path.join(__dirname, 'public')));
    return
)

app.configure(
  'development',
  ->
    app.use(express.errorHandler())
)

app.get '/', routes.index
app.get '/users', user.list

server = http.createServer app
server.listen(
  app.get 'port'
  ->
    console.log 'Express server listening on port ' + app.get 'port'
)

WebSocket = require 'ws'
WebSocketServer = WebSocket.Server
webSocketServer = new WebSocketServer({server:server})

webSocketServer.on(
  'connection',
  (ws)->
    console.log 'connected'
    ws.on(
      'message'
      (data, flag) ->
        console.log data, flag
        ws.send data
    )    
)

