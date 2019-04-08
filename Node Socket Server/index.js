var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});

io.on('connection', function(socket){
  console.log('a user connected');
  socket.on('HR', function(msg){
    console.log('message: ' + msg);
    console.log('emitting: ' + msg);
    //socket.broadcast.emit("hrdata", msg);
    io.sockets.emit("hrdata", msg);
  });
  socket.on('disconnect', function(){
    console.log('user disconnected');
  });
});

http.listen(3000, function(){
  console.log('listening on 0.0.0.0:3000');
});
