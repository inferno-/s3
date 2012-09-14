fs = require "fs"
knox = require "knox"

class MediaManager
  constructor: (settings) ->
    @s3Bucket = settings.bucket
    @s3Client = knox.createClient settings

  storeMedia: (localPath, metaData, callback) ->
    # callback expects a dict with media ids
    stream = fs.createReadStream localPath
    s3Headers = @getS3HeadersForMetaData metaData
    metaData.name = metaData.name.replace(/\ /g, "_")
    @s3Client.putStream stream, metaData.name, s3Headers, (err, res) =>
      fs.unlink localPath, (err) ->
      if err
        callback new Error("Failed to store media"), null
        return
      console.log "Successfully uploaded #{metaData.filename}"
      metaData.url = @generateMediaUrlForId metaData.name
      metaData.thumbnail_url = @generateMediaUrlForId metaData.name
      callback null, metaData

  getS3HeadersForMetaData: (metaData) ->
    return {"Content-Type": metaData.contentType ? "application/octet-stream"}

  generateMediaUrlForId: (name) ->
    return "http://#{@s3Bucket}.s3.amazonaws.com/#{name}"

module.exports = MediaManager