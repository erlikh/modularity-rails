#= require modularity/data/ajax_loader
#= require modularity/data/indexed_cache
#= require modularity/tools/object_tools

# Provides persistence services for data models.
class modularity.PersistenceManager

  constructor: (params) ->
    
    # Copy of the data as it is on the server.
    @server_data = new modularity.IndexedCache 'id'
    
    # Copy of the data as it is on the client.
    @client_data = new modularity.IndexedCache 'id'
    
    # The base url on the server. Expected to be a fully RESTful API.
    @base_url = params.url

    @key = params.key or 'id'
  
    # For handling parallel requests to the server.
    @loader = new modularity.AjaxLoader { cache: no }


  # Adds the given data objects to the server cache.
  add_all: (data) ->
    @server_data.add_all data


  # Returns the URL to access the collection of objects.
  collection_url: ->
    "#{@base_url}.json"


  # Creates the given object on the server.
  create: (obj, callback) ->
    jQuery.ajax {
      url: @collection_url()
      type: 'POST'
      data: obj
      success: (server_obj) =>
        @server_data.add server_obj
        callback server_obj
    }


  delete: (obj, callback) ->
    @client_data.remove obj
    @server_data.remove obj
    jQuery.ajax {
      url: @entry_url(obj)
      type: 'DELETE'
      success: ->
        callback() if callback?
    }


  # Returns the url to access a single entry.
  entry_url: (entry) ->
    "#{@base_url}/#{entry[@key]}.json"


  # Returns the entry with the given key.
  load: (key, callback) ->
    
    entry = @load_local key
    return callback(entry) if entry

    # No data on client at all --> load data from server.
    @loader.get "#{@base_url}/#{key}", (server_entry) =>
      @server_data.add server_entry
      client_entry = modularity.clone_hash server_entry
      @client_data.add client_entry
      callback client_entry


  # Loads all objects from the server.
  # Provides the given params as parameters to the GET request.
  load_all: (callback, params) ->
    jQuery.ajax {
      url: @collection_url()
      cache: no
      data: params
      success: (data) =>
        @server_data.add_all data
        callback()
    }


  # Loads the entry synchronously from the cache.
  # Doesn't fall back to the server.
  load_local: (key) ->

    # Try to use client_data cache.
    client_obj = @client_data.get key
    return client_obj if client_obj

    # No data in client cache --> try to use server cache.
    server_obj = @server_data.get key
    return null unless server_obj
    client_obj = modularity.clone_hash server_obj
    @client_data.add client_obj
    client_obj
 

  # Returns all entries with the given keys.
  load_many: (keys, callback) ->
    result = []
    for key in keys
      do (key) =>
        entry = @load_local key
        result.push entry if entry
    callback result


  # Saves the given object.
  # Does the right thing (create or update) dependent on
  # whether the object already has a key parameter.
  save: (obj, callback) ->
    if obj[@key]?
      @update obj, callback
    else
      @create obj, callback


  # Updates the given object.
  # The given object must exist on the server already,
  # and have a proper value in the key attribute.
  update: (obj, callback) ->
    
    # Create a new hash, containing only the changed attributes between obj and it's replica in @server_data.
    diff_obj = modularity.object_diff @server_data.get(obj[@key]), obj
    return if modularity.object_length(diff_obj) == 0
    
    # Add key attribute.
    diff_obj[@key] = obj[@key]
    
    # Update server_data version.
    @server_data.add obj

    # Send to server
    jQuery.ajax {
      url: @entry_url(obj)
      type: 'PUT'
      data: diff_obj
      success: (server_obj) =>
        @server_data.add server_obj
        callback server_obj if callback
    }

