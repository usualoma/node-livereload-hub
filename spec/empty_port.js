exports.empty_port = function(callback) {
    port = 10000 + Math.floor(Math.random() * 1000);

    var net = require('net');
    var socket = new net.Socket();
    var server = new net.Server();

    socket.on('error', function(e) {
        try {
            server.listen(port, '127.0.0.1');
            server.close();
            callback(null, port);
        } catch(e) {
            loop();
        };
    });
    function loop() {
        if (port++ >= 20000) {
            callback(new Error('empty port not found'));
            return;
        }

        socket.connect(port, '127.0.0.1', function() {
            socket.destroy();
            loop();
        });
    };
    loop();
};
