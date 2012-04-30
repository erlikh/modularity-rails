#= require spec_helper

describe 'test environment setup', ->

  it 'loading libraries', ->
    load_modularity()
    loadCS "/vendor/assets/javascripts/mixins/closable.coffee"

    class window.ClosableModuleStandard extends Module
      @mixin closable


describe 'Closable', ->
  template 'closable.html'

  describe 'constructor', ->
    it 'shows an alert if there is no close button', ->
      spy = spyOn window, 'alert'
      new ClosableModuleStandard('#test #closable3')
      expect(spy).toHaveBeenCalled()
      expect(spy.argsForCall[0][0]).toMatch(/close button not found/i)

    it 'shows no alert if there is a close button', ->
      spy = spyOn window, 'alert'
      new ClosableModuleStandard('#test #closable1')
      expect(spy).not.toHaveBeenCalled()

    it 'finds the close button div automatically', ->
      new ClosableModuleStandard('#test #closable1')
      $('#test #closable1 .CloseButton').click()
      expect($('#test #closable1').length).toEqual(0)


  describe 'when clicking the close button', ->
    it 'removes the container', ->
      new ClosableModuleStandard('#test #closable1')
      $('#test #closable1 .CloseButton').click()

      expect($('#test #closable1').length).toEqual(0)
      
    
    it "fires the 'closed' event", ->
      closable_module = new ClosableModuleStandard('#test #closable1')
      closable_module.bind_event('closed', (spy = jasmine.createSpy()))

      $('#test #closable1 .CloseButton').click()

      expect(spy).toHaveBeenCalled()
      expect(spy.callCount).toEqual(1)
