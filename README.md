# node-livereload-hub

Yet another implementation of the [LiveReload](https://github.com/mockko/livereload) server in Node.js.

This server makes browsers reload via the HTTP request.


## Quick start

Install:

    $ npm install livereload-hub

Run the server:

    $ livereload-hub

Connect to the server:

    Install and enable LiveReload plugin on your browser

Send request for reloading:

    $ curl your-livereload-hub.example.com:35729


## Command line options

### Listen port
    -p, --port <number>

### LiveReload API version
    -a, --api-version <version>

### Log level
    --log-level fatal|error|warn|info|debug

### Log file
    --log-file <filename>

### Disable host header matching
Use this option when you don't use name based virtual host.

    --disable-host-header-matching


## Name based virtual host
This server compare the host header, and reload only if the server received same header.


## Customize
You can customize this server by using "livereload-hub" as a library.

    # simple server
    livereload_hub = require('livereload-hub')
    server = livereload_hub.createServer()
    server.setOptions(
      http_callback: (request, response) ->
        message = JSON.stringify [ "refresh",
          path: request.url
        ]
        for key, c of @clients
          c.connection.sendUTF message

        response.writeHead 200
        response.write 'OK'
        response.end()
    )
    server.listen 35729
    

## License

This software is distributed under the MIT license.


## See also

#### node-livereload
An implementation of the LiveReload server in Node.js.
[josh/node-livereload](https://github.com/josh/node-livereload)
