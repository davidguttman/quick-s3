fs = require 'fs'
knox = require 'knox'
path = require 'path'
Progress = require 'progress'

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

putStream = client.putFile target, dest, (err, res) -> res.resume()

bar = null
putStream.on 'progress', (prog) ->
  if not bar
    bar = new Progress 'Uploading [:bar] :percent :etas',
      total: prog.total
      width: 80
      complete: '='
      incomplete: ' '

  bar.update prog.percent/100
