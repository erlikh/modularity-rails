# This mixin adds a 'clickable' aspect to modules.
# This means clicking anywhere on the module fires the 'clicked' event.
window.modularity.clickable =

  constructor: ->
    @container.click @container_clicked


  # Events that are fired by this mixin.
  events:
    clicked: 'clicked'

  
  # Programmatically click this clickable element.
  # For testing and scripting.
  click: -> @container.click()


  # Event handler for clicks on this clickable element. 
  container_clicked: -> @fire_event modularity.clickable.events.clicked

