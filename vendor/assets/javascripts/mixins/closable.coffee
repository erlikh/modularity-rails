window.closable =

  constructor: (container) ->
    close_button = @container.find('.CloseButton')
    unless close_button?.length > 0
      window.alert 'Error: Close button not found'
    close_button.click => @close_button_clicked()


  # The events that can be fired by closable objects.
  events:
    closed: 'closed'


  # Called when the button got clicked by the user or programmatically.
  close_button_clicked: ->
    if @closable_closing
      return unless @closable_closing()
    @fire_event 'closed'
    @container.remove()
    @closable_closed() if @closable_closed
