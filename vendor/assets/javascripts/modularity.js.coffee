# The Modularity framework written specificially for CoffeeScript.
#
# Use UglifyJS (http://github.com/mishoo/UglifyJS) for compression.
#
# Please see https://github.com/kevgo/modularity for more information.


window.modularity = {

  # Checks whether the given condition is true.
  # Shows an alert with the given message if not.
  assert: (condition, message) ->
    condition_ok = condition?.length > 0
    alert(message) unless condition_ok
    condition_ok


  # GLOBAL EVENTS.

  # Subscribes to the given global event,
  # i.e. calls the given function when the given global event type happens.
  bind_global_event: (event_type, callback) ->
    return unless modularity.assert event_type, "modularity.bind_global_event: parameter 'event_type' is empty"
    return alert "modularity.bind_global_event: parameter 'callback' must be a function, #{callback} (#{typeof callback}) given." unless typeof callback == 'function'
    modularity.global_event_container().bind event_type, callback

  # Fires the given global event with the given data payload.
  fire_global_event: (event_type, data) ->
    modularity.assert event_type, 'Module.fire_global_event: You must provide the event type to fire.'
    return alert("Module.fire_global_event: Event type must be a string, #{event_type} (#{typeof event_type}) given.") unless typeof event_type == 'string'
    modularity.global_event_container().trigger event_type, data ?= []

  # Returns the DOM object that is used to fire global events on.
  global_event_container: -> modularity.global_event_container_cache or= $(window)
}


class window.modularity.Module

  # The container variable is required. Provide 'testing' in tests.
  constructor: (container) ->
    container = $(container) if (typeof container == 'string') and container != 'testing'
    @container = container

    return alert 'Error in Module constructor: No container given.' unless @container?
    if container != 'testing'
      return alert 'Error in Module constructor: The given container must be a jQuery object.' unless typeof container.jquery == 'string'
      return alert "Error in Module constructor: The given container ('#{container.selector}') is empty." unless container? and container.length > 0
      return alert "Error in Module constructor: The given container ('#{container.selector}') has more than one element." unless container? and container.length == 1


    # Attach mixins.
    if @mixins?
      for mixin_data in @mixins
        
        # Attach all properties from mixin to the prototype.
        for methodName, method of mixin_data.mixin
          do (methodName, method) => unless @[methodName]
            @[methodName] = => method.apply(@, arguments)

        # Call constructor function from mixin.
        mixin_data.mixin.constructor.apply @, arguments


  # MODULE EVENTS.

  # Calls the given function when this widget fires the given local event.
  bind_event: (event_type, callback) =>
    return unless modularity.assert event_type, "Module.bind_event: parameter 'event_type' is empty"
    return alert "Module.bind_event: parameter 'callback' must be a function, #{callback} (#{typeof callback}) given." unless typeof callback == 'function'
    @container.bind event_type, callback

  # Fires the given local event with the given data payload.
  fire_event: (event_type, data) =>
    modularity.assert event_type, 'Module.fire_event: You must provide the event type to fire.'
    return alert("Module.fire_event: Event type must be a string, #{event_type} (#{typeof event_type}) given.") unless typeof event_type == 'string'
    @container.trigger event_type, data ?= {}


  # mixin = constructor of Draggable
  # self = Card
  @mixin: (mixin, p...) ->
    @prototype.mixins or= []
    @prototype.mixins.push({mixin: mixin, params: p})


# jQuery integration for creating Modules.
#
# Call like this: myModule = $('...').module(MyModuleClass)
#
# Parameters:
# * klass: the class of the Module to instantiate
# * any additional parameters are forwarded to the Module constructor.
# Returns the created module instance.
#
# Messages errors in alert boxes.
#
jQuery.fn.module = (klass, args...) ->

  # Check parameters.
  if typeof klass != 'function'
    return alert "ERROR!\n\nYou must provide the Module class when calling $.module().\n\nExample: $('...').module(MyModuleClass)\n\nYou provided: #{klass} (#{typeof klass})" 

  # Instantiate the class and return the instance.
  new klass(this, args...)
