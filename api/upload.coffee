media = (app) ->
  app.post '/api/media/upload', (req, res) ->
    console.log "Uploaded files", req.files.files
    if req.files.files.length is 0
      res.json error: "no file"
      return
    file = req.files.files[0]
    console.log "Uploaded file", file
    xhr = true if req.header("X-Requested-With") is "XMLHttpRequest"
    metaData =
      name: file.filename
      size: file.size
      contentType: file.mime
    app.mediaManager.storeMedia file.path, metaData, (err, metadata) ->
      console.log "media storeMedia result", metaData
      if err
        resp = error: err.toString()
      else
        resp = [metadata]
      if not xhr
        resp = JSON.stringify(resp)
        res.send "<textarea>#{resp}</textarea>"
      else
        res.json resp

module.exports = media
