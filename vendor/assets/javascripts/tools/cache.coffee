# A generic cache.
# Stores key-value pairs.
class window.Cache

  constructor: ->
    @cache = {}


  # Adds the given entry to the cache.
  # Overwrites existing entries.
  add: (key, value) ->
    @cache[key] = value


  # Returns the entry with the given key from the cache, or NULL if no entry exists.
  get: (key) ->
    @cache[key]


  # Looks up several entries at once.
  # Returns a hash of found entries, and a list of missing entries.
  getMany: (keys) ->
    result = { found: {}, missing: [] }
    for key in keys
      do (key) =>
        value = @cache[key]
        if value
          result.found[key] = value
        else
          result.missing.push key
    result


  # Replaces the cache with the given data.
  replaceAll: (data) ->
    @cache = data


  # Returns the number of cached objects.
  length: () ->
    # TODO(KG): This doesn't work in IE8.
    Object.keys(@cache).length

