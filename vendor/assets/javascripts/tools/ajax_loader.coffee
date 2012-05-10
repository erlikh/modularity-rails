# A generic ajax loader for parallel GET requests.
# Prevents duplicate requests, caches the responses
# to answer subsequent requests immediately
# without additional server requests.
#
# Warning: Caches the responses, so once a request is cached,
#          any new content on the same URL will not be visible!
modularity.loader =

  cache: {}

  get: (url, callback) ->
    cache = modularity.loader.cache[url]

    # New request --> start GET call, store callback.
    unless cache?
      modularity.loader.cache[url] = [callback]
      return jQuery.get url, (data) ->
        cb(data) for cb in modularity.loader.cache[url]
        modularity.loader.cache[url] = data

    # Request while the GET call is still pending --> 
    # add the given callback to the list of waiting callbacks.
    if cache.constructor is Array
      return cache.push callback

    # There is a cached response for this request --> answer the request immediately.
    callback(cache)
