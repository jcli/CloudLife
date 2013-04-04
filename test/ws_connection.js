var vows = require('vows');
var assert = require('assert');

vows.describe('Test server').addBatch({
    // 'when openning a websocket connection from the client':{ //context
    //     topic: function(){

    //     }
    // }
    'when requesting the server':{ //context
        topic: function(){
            var http = require('http');
            var options = {
                host: 'localhost',
                port: 3000,
                path: '/'
            };
            callback = this.callback;
            http.get(options, function(res){
                callback(null, res);
            }).on('error', function(e){
                callback(e, null)
            });
        },
        'should equal to 200':function(e, res){
            assert.equal(res.statusCode,200);
        }
    }
}).run();
