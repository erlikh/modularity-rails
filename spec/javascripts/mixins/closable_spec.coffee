#= require spec_helper

describe 'test environment setup', ->

  it 'loading libraries', ->
    load_modularity()
    loadCS "/vendor/assets/javascripts/mixins/closable.coffee"

    # A standard closable module.
    class window.ClosableModule1 extends modularity.Module
      @mixin modularity.closable


describe 'Closable', ->
  template 'closable.html'

  describe 'constructor', ->
    it 'shows an alert if there is no close button', ->
      spy = spyOn window, 'alert'
      new ClosableModule1('#test #closable3')
      expect(spy).toHaveBeenCalled()
      expect(spy.argsForCall[0][0]).toMatch(/close button not found/i)

    it 'shows no alert if there is a close button', ->
      spy = spyOn window, 'alert'
      new ClosableModule1('#test #closable1')
      expect(spy).not.toHaveBeenCalled()

    it 'finds the close button div automatically', ->
      new ClosableModule1('#test #closable1')
      $('#test #closable1 .CloseButton').click()
      expect($('#test #closable1').length).toEqual(0)


  describe 'when clicking the close button', ->

    it "calls the closable_closing hook on the object if it exists", ->

      # A closable module with the 'closing' hook.
      class ClosableModule extends modularity.Module
        @mixin modularity.closable

        constructor: ->
          super
          @closing_hook_got_called = no

        closable_closing: =>
          @closing_hook_got_called = yes

      module = new ClosableModule('#test #closable1')
      $('#test #closable1 .CloseButton').click()
      expect(module.closing_hook_got_called).toBeTruthy()


    it "calls the closable_closed hook on the object if it exists", ->

      # A closable module with the 'closed' hook.
      class ClosableModule extends modularity.Module
        @mixin modularity.closable

        constructor: ->
          super
          @closed_hook_got_called = no

        closable_closed: =>
          @closed_hook_got_called = yes

      module = new ClosableModule('#test #closable1')
      $('#test #closable1 .CloseButton').click()
      expect(module.closed_hook_got_called).toBeTruthy()


    it "aborts the close operation if the closable_closing method returns false", ->

      class ClosableModuleWithHookThatReturnsFalse extends modularity.Module
        @mixin modularity.closable
        closable_closing: -> false

      module = new ClosableModuleWithHookThatReturnsFalse('#test #closable1')
      module.bind_event('closed', (spy = jasmine.createSpy()))

      $('#test #closable1 .CloseButton').click()

      expect(spy).not.toHaveBeenCalled()


    it 'removes the container', ->
      new ClosableModule1('#test #closable1')
      $('#test #closable1 .CloseButton').click()

      expect($('#test #closable1').length).toEqual(0)


    it "fires the 'closed' event", ->
      closable_module = new ClosableModule1('#test #closable1')
      closable_module.bind_event('closed', (spy = jasmine.createSpy()))

      $('#test #closable1 .CloseButton').click()

      expect(spy).toHaveBeenCalled()
      expect(spy.callCount).toEqual(1)
