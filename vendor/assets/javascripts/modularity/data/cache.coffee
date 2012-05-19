#= require modularity/tools/object_tools

# A generic cache.
# Stores key-value pairs.
class window.modularity.Cache

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
  get_many: (keys) ->
    result = { found: {}, missing: [] }
    for key in keys
      do (key) =>
        value = @cache[key]
        if value
          result.found[key] = value
        else
          result.missing.push key
    result
  getMany: Cache::get_many


  # Returns the number of cached objects.
  length: () ->
    modularity.object_length @cache


  # Removes the entry with the given key.
  remove: (key) =>
    delete @cache[key]


  # Replaces the cache with the given data.
  # When 'key' is given, treats 'data' as an array of objects, and indexes each element by the given key.
  # When 'key' is not given, treats 'data' as an already indexed hash object.
  replace_all: (data, key) ->
    if key
      # Key given --> index the data array.
      @add(entry[key], entry) for entry in data
    else
      # Key not given --> use data as the new cache.
      @cache = data
  replaceAll: Cache::replace_all

