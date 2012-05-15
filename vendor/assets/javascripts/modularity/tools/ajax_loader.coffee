#= require tools/cache


# A generic ajax loader for parallel GET requests.
# Prevents duplicate requests, caches the responses
# to answer subsequent requests immediately
# without additional server requests.
#
# Warning: Caches the responses, so once a request is cached,
#          any new content on the same URL will not be visible!
class window.modularity.AjaxLoader

  constructor: ->
    @cache = new modularity.Cache()


  get: (url, callback) ->
    cached_value = @cache.get url

    # New request --> start GET call, store callback.
    unless cached_value?
      @cache.add url, [callback]
      return jQuery.get url, (data) =>
        cb(data) for cb in @cache.get(url)
        @cache.add url, data

    # Request while the GET call is still pending --> 
    # add the given callback to the list of waiting callbacks.
    if cached_value.constructor is Array
      return cached_value.push callback

    # There is a cached response for this request --> answer the request immediately.
    callback(cached_value)
