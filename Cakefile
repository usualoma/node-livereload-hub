{spawn, exec} = require 'child_process'

# Tasks
task 'test', 'Run tests', ->
  run "jasmine-node --coffee spec"

task 'build', 'Builds the browser version', ->
  {readFileSync, writeFileSync} = require('fs')
  {compile} = require('coffee-script')

  run 'mkdir -p dist'

  output = [
    compile(readFileSync('lib/livereload-hub.coffee', 'utf-8'))
  ]

  combined   = output.join("\n")
  compressed = pack(combined)

  writeFileSync 'dist/livereload-hub.js', combined
  writeFileSync 'dist/livereload-hub.min.js', compressed

  console.log '* dist/livereload-hub.js'
  console.log '* dist/livereload-hub.min.js'

# Helpers
run = (cmd, callback, options={}) ->
  console.warn "$ #{cmd}"  unless options.quiet?

  exec cmd, (err, stdout, stderr) ->
    callback()  if typeof callback == 'function'
    console.warn stderr  if stderr
    console.log stdout   if stdout

# Compress JS with simple regexes. (Because common packers
# seem to munge Narcissus badly)
pack = (str) ->
  spaces        = new RegExp(' *(\n *)+', 'g')
  comments      = /\/\*(\n|.)*?\*\//g
  line_comments = /\/\/.*\n/g

  compressed = str
  compressed = compressed.replace(comments, " ")
  compressed = compressed.replace(line_comments, "\n")
  compressed = compressed.replace(spaces, "\n")

  compressed

task 'doc', 'Builds docs', ->
  run "docco lib/livereload-hub.coffee"
