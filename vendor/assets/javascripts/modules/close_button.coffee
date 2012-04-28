# Module for managing close buttons.
# Removes the given container element when clicking on the '.CloseButton' child of it.
class window.CloseButton extends Module

  constructor: (container, close_button = undefined) ->
    super
    close_button ||= @container.find('.CloseButton')
    close_button.click(@close_button_clicked)


  # The different events that this button can fire.
  @events = closed: 'Closed'


  # Called when the button got clicked by the user or programmatically.
  close_button_clicked: =>
    @fire_event CloseButton.events.closed
    @container.remove()
