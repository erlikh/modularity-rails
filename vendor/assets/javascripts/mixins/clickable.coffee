window.clickable =

  constructor: ->
    @container.click @container_clicked


  # The different events that this button can fire.
  events:
    clicked: 'clicked'      # Called when this clickable element is clicked.

  
  # Programmatically click this clickable element.
  click: -> @container_clicked()


  # Called when the clickable element got clicked. 
  container_clicked: ->
    console.log 'clicked'
    @fire_event clickable.events.clicked

