fs = require 'fs'
knox = require 'knox'
path = require 'path'
Progress = require 'progress'
humanFormat = require 'human-format'
MultiPartUpload = require 'knox-mpu'

try
  creds = require process.env.HOME + '/.quick-s3.json'
catch e
  console.error 'No options file found at ~/.quick-s3.json'
  console.error 'Example:'
  console.error '{'
  console.error '  "key": "<api-key-here>",'
  console.error '  "secret": "<secret-here>",'
  console.error '  "bucket": "<bucket-name>"'
  console.error '}'
  process.exit 1



client = knox.createClient creds

[target, dest] = process.argv[2..3]

unless target
  console.error 'No file to transfer specified.'
  process.exit 1

unless dest
  dest = path.basename target

console.log "Uploading"
console.log "From: #{target}"
console.log "To:   #{dest}"

fs.stat target, (err, stats) ->
  return console.error err if err

  upload = new MultiPartUpload
    file: target
    client: client
    objectName: dest
  , (err, res) ->
    return console.error err if err
    console.log 'res', res

  bar = null
  lastWritten = 0
  lastTime = Date.now()

  bar = new Progress 'Uploading :speed [:bar] :percent Elapsed: :elapseds ETA: :etas',
    total: stats.size
    width: 60
    complete: '='
    incomplete: ' '

  bar.update 0, speed: ''

  upload.on 'progress', (prog) ->
    now = Date.now()
    written = prog.written - lastWritten
    elapsed = (now - lastTime)/1000
    speed = humanFormat(written / elapsed) + '/s'

    bar.update prog.percent/100, speed: speed
