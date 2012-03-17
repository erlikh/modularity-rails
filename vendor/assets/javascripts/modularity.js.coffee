# The Modularity framework written specificially for CoffeeScript.
#
# Use UglifyJS (http://github.com/mishoo/UglifyJS) for compression.
#
# Please see https://github.com/kevgo/modularity for more information.

class window.Module

  # The container variable is required. Provide 'null' in tests.
  constructor: (@container) ->
    alert('Module constructor: No container given.') unless @container? and @container.length > 0

  # Checks whether the given condition is true. 
  # Shows an alert with the given message if not.    
  assert: (condition, message) ->
    alert(message) unless condition? and condition.length > 0

  # Calls the given function when this widget fires the given local event.
  bind_event: (event_type, callback) =>
    @assert event_type, "Module.bind_event: parameter 'event_type' is empty"
    @container.bind event_type, callback

  # Fires the given local event with the given data payload.
  fire_event: (event_type, data) =>
    @assert event_type, 'Module.fire_event: You must provide the event type to fire.'
    @container.trigger event_type, data or {}

  # Subscribes to the given global event, 
  # i.e. calls the given function when the given global event type happens.
  bind_global_event: (event_type, callback) =>
    @assert event_type, "Module.bind_global_event: parameter 'event_type' is empty"
    @global_event_container().bind event_type, callback

  # Fires the given global event with the given data payload.
  fire_global_event: (event_type, data) =>
    @assert event_type, 'Module.fire_global_event: You must provide the event type to fire.'
    @global_event_container().trigger event_type, data or []

  # Returns the DOM object that is used to fire global events on.
  global_event_container: =>
    @global_event_container_cache or= $(window)
