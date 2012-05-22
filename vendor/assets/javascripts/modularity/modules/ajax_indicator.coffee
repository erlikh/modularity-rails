# Indicates that an AJAX request is running.
class sn.AjaxIndicator extends modularity.Module

  constructor: ->

    # The number of currently running ajax requests.
    @ajax_counter = 0

    @searchManager.bind_event sn.SearchManager.events.AJAX_LOADING, @ajax_loading
    @searchManager.bind_event sn.SearchManager.events.AJAX_LOADED, @ajax_loaded


  # Called when an ajax request starts.
  ajax_loading: =>
    @container.addClass 'loading' if @ajax_counter == 0
    @ajax_counter += 1


  # Called when the ajax request is done.
  ajax_loaded: =>
    @ajax_counter -= 1
    @ajax_counter = 0 if @ajax_counter <= 0
    @container.removeClass 'loading'

