#= require spec_helper

describe 'test environment setup', ->

  it 'loading libraries', ->
    load_modularity()
    loadCS "/vendor/assets/javascripts/mixins/clickable.coffee"
    loadCS "/vendor/assets/javascripts/modules/button.coffee"
    loadCS "/vendor/assets/javascripts/modules/counter_button.coffee"


describe 'CounterButton', ->
  template 'button.html'

  describe 'standard button functionality', ->

    describe 'manual clicks', ->

      it 'fires when clicking on the container directly', ->
        button = new modularity.CounterButton('#test #button1')
        button.bind_event('clicked', (spy = jasmine.createSpy()))

        button.container.click()

        expect(spy).toHaveBeenCalled()
        expect(spy.callCount).toEqual(1)


      it 'fires when clicking embedded elements of the button', ->
        button = new modularity.CounterButton('#test #button2')
        button.bind_event('clicked', (spy = jasmine.createSpy()))

        button.container.find('.embedded').click()

        expect(spy).toHaveBeenCalled()
        expect(spy.callCount).toEqual(1)

    describe 'programmatic clicks', ->

      it 'programmatically clicks the button', ->
        button = new modularity.CounterButton('#test #button2')
        spy = jasmine.createSpy()
        button.bind_event('clicked', spy)

        button.click()

        expect(spy).toHaveBeenCalled()
        
  describe 'CounterButton specific functionality', ->

    it 'provides the click counter as the event payload', ->
      button = new modularity.CounterButton('#test #button1')
      button.bind_event('clicked', (spy = jasmine.createSpy()))

      button.container.click()
      button.container.click()
      button.container.click()

      expect(spy.callCount).toEqual(3)
      expect(spy.argsForCall[0][1]).toEqual(1)
      expect(spy.argsForCall[1][1]).toEqual(2)
      expect(spy.argsForCall[2][1]).toEqual(3)


