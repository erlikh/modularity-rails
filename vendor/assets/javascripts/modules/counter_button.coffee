# A button that counts how often it is clicked.
# This is implemented as a subclass of Button, 
# to take advantage of the already existing functionality there.
class window.modularity.CounterButton extends modularity.Button

  constructor: ->
    super

    # Counts how often this button has been clicked so far.
    @click_count = 0


  # We override the event handler for the 'clicked' event here.
  container_clicked: =>
    @fire_event 'clicked', ++@click_count
