


Module.loader =

  cache: {}

  get: (url, callback) ->
    cache = Module.loader.cache[url]

    unless cache?
      Module.loader.cache[url] = [callback]
      return jQuery.get url, (data) ->
        cb(data) for cb in Module.loader.cache[url]
        Module.loader.cache[url] = data

    if cache.constructor is Array
      return cache.push callback

    callback(cache)
