# node-livereload-hub

Yet another implementation of the [LiveReload](https://github.com/mockko/livereload) server in Node.js.

This server makes browsers reload via the HTTP request.


## Installation

    $ npm install livereload-hub


## Usage

Run the server:

    $ livereload-hub [--port port] [--api-version version] [--log-file filename] [--log-level fatal|error|warn|info|debug] [--ignore-host-matching]

Connect to the server:

    Enable LiveReload in the browser

Send request for reloading:

    $ curl your-livereload-hub.example.com:35729


## License

This software is distributed under the MIT license.


## See also

#### node-livereload
An implementation of the LiveReload server in Node.js.
[josh/node-livereload](https://github.com/josh/node-livereload)
