# A button module.
# Responds to clicks on the container element.
# The container element is expected to already be populated.
class window.Button extends Module

  constructor: (container) ->
    super container
    @container.click @container_clicked


  # The different events that this button can fire.
  @events =
    clicked: 'Button_clicked'      # Called when this button is clicked.


  # Programmatically click this button.
  click: => @container_clicked()


  # Called when the button got clicked. 
  container_clicked: => @fire_event Button.events.clicked

