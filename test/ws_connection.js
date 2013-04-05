var vows = require('vows');
var assert = require('assert');

var host = 'localhost';
//var host = 'jc_lij-cloudlife.jit.su';
//var port = 80;
var port = 3000;
vows.describe('Test server').addBatch({
    'when requesting the server':{ //context
        topic: function(){
            var http = require('http');
            var options = {
                host: host,
                port: port,
                path: '/'
            };
            var callback = this.callback;
            http.get(options, function(res){
                callback(null, res);
            }).on('error', function(e){
                callback(e, null)
            });
        },
        'should equal to 200':function(e, res){
            assert.isNull(e);
            assert.equal(res.statusCode,200);
        }
    },

    'when openning a websocket to the server':{
        topic: function(){   
            var WebSocket=require('../node_modules/ws');
            var wss = new WebSocket('ws://'+host+':'+port);
            var callback = this.callback;
            wss.on('open', function() {
                wss.close();
            });
            wss.on('close', function(){
                callback(null, true);
            });
            wss.on('error', function(error){
                callback(error, false);
            });
        },
        'should not have error':function(e, res){
            assert.isNull(e);
        }
    }
}).export(module);
