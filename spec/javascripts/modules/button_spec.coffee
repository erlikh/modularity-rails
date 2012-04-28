#= require spec_helper

describe 'setting up test environment', ->

  it 'loading libraries', ->
    load_modularity()
    loadCS "/vendor/assets/javascripts/modules/button.coffee"


describe 'Button', ->
  template 'button.html'
  
  describe 'manual clicks', ->

    it 'fires when clicking on the container directly', ->
      button = new window.Button($('#test #button1'))
      spyOn(button, 'fire_event')

      button.container.click()

      expect(button.fire_event).toHaveBeenCalledWith(Button.events.clicked)


    it 'fires when clicking embedded elements of the button', ->
      button = new window.Button($('#test #button2'))
      spyOn(button, 'fire_event')

      button.container.find('.embedded').click()

      expect(button.fire_event).toHaveBeenCalledWith(Button.events.clicked)


  describe 'programmatic clicks', ->

    it 'programmatically clicks the button', ->
      button = new window.Button($('#test #button2'))
      spyOn(button, 'fire_event')

      button.click()

      expect(button.fire_event).toHaveBeenCalledWith(Button.events.clicked)
