#= require modularity/data/cache

# Provides fast and convenient retrieval of hash objects 
# by indexing them on a given key column.
class modularity.IndexedCache

  constructor: (@key) ->
    @cache = new modularity.Cache

  
  add: (entry) ->
    @cache.add entry[@key], entry


  add_all: (entries) ->
    @add(entry) for entry in entries


  delete: (entry) ->
    @cache.delete entry[@key]

  get: (key) ->
    @cache.get key


  length: => @cache.length()
