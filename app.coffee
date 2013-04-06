
# module dependencies
#

express = require 'express'
routes  = require './routes'
user    = require './routes/user'
https   = require 'https'
http    = require 'http'
path    = require 'path'
fs      = require 'fs'
winston = require 'winston'

app = express()
if (not fs.existsSync('./log'))
  fs.mkdirSync('./log')
winston.add winston.transports.File, { filename: './log/server.log' }
winston.remove winston.transports.Console

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

server = http.createServer app
server.listen(
  app.get 'port'
  ->
    winston.info '***'
    winston.info 'Server started listening on port ' + app.get 'port'
)

WebSocket = require 'ws'
WebSocketServer = WebSocket.Server
wsServer = new WebSocketServer({server:server})

wsManager = require './ws_manager/connection'
connections = new wsManager.Connections
wsServer.on(
  'connection',
  (ws)->
    connection = new wsManager.Connection(ws, connections)
    connections.masterList[connection.id]=connection
)
