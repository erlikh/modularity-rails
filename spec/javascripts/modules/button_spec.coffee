#= require spec_helper

describe 'test environment setup', ->

  it 'loading libraries', ->
    load_modularity()
    loadCS "/vendor/assets/javascripts/mixins/clickable.coffee"
    loadCS "/vendor/assets/javascripts/modules/button.coffee"


describe 'Button', ->
  template 'button.html'
  
  describe 'manual clicks', ->

    it 'fires when clicking on the container directly', ->
      button = new modularity.Button($('#test #button1'))
      button.bind_event('clicked', (spy = jasmine.createSpy()))

      button.container.click()

      expect(spy).toHaveBeenCalled()
      expect(spy.callCount).toEqual(1)


    it 'fires when clicking embedded elements of the button', ->
      button = new modularity.Button($('#test #button2'))
      button.bind_event('clicked', (spy = jasmine.createSpy()))

      button.container.find('.embedded').click()

      expect(spy).toHaveBeenCalled()
      expect(spy.callCount).toEqual(1)


  describe 'programmatic clicks', ->

    it 'programmatically clicks the button', ->
      button = new modularity.Button($('#test #button2'))
      spy = jasmine.createSpy()
      button.bind_event('clicked', spy)

      button.click()

      expect(spy).toHaveBeenCalled()
