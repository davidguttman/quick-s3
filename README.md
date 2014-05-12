# Quick S3 #

Quickly upload to S3.

First, install with npm:

    npm i -g quick-s3

Next, create a json file at ~/.quick-s3.json with your key, secret, and bucket:

    {
      "key": "<api-key-here>",
      "secret": "<secret-here>",
      "bucket": "somebucket"
    }

To send something to S3:

    quick-s3 path/to/file.ext [destination/filename.ext]

# License #

MIT
