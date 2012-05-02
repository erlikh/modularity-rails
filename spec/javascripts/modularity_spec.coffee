#= require spec_helper

describe 'setting up test environment', ->

  it 'loading libraries', ->
    load_modularity()

  it 'defining test classes', ->

    class window.TestModule extends Module
      constructor: (container) ->
        super


describe 'modularity', ->

  template 'test.html'

  describe 'constructor', ->

    beforeEach ->
      spyOn window, 'alert'

    it "is defined on the 'window' object", ->
      expect(window.Module).not.toBeUndefined()

    it 'shows an error if no container is given', ->
      new TestModule()
      expect(alert).toHaveBeenCalled()

    it 'tries to load the DOM if the given container is a string', ->
      new TestModule('#test #module_container')
      expect(alert).not.toHaveBeenCalled()

    it 'shows an error if the container is not a jQuery object', ->
      new TestModule({})
      expect(alert).toHaveBeenCalled()

    it 'shows an error if the container is an empty jQuery object', ->
      new TestModule($('#test .zonk'))
      expect(alert).toHaveBeenCalled()

    it 'shows an error if the container has more than one elements', ->
      new TestModule($('#test .double'))
      expect(alert).toHaveBeenCalled()

    it "allows to provide 'testing' in tests", ->
      new TestModule('testing')
      expect(alert).not.toHaveBeenCalled()


  describe 'assert', ->

    beforeEach ->
      spyOn window, 'alert'

    it 'shows an alert with the given message if the given condition is false', ->
      Module.assert false, 'Message'
      expect(alert).toHaveBeenCalledWith("Message")

    it 'fails when the condition is null', ->
      Module.assert null, 'Message'
      expect(alert).toHaveBeenCalledWith("Message")

    it 'fails when the condition is undefined', ->
      Module.assert undefined, 'Message'
      expect(alert).toHaveBeenCalledWith("Message")

    it 'fails when the condition is an empty array', ->
      Module.assert [], 'Message'
      expect(alert).toHaveBeenCalledWith("Message")

    it 'fails when the condition is an empty string', ->
      Module.assert '', 'Message'
      expect(alert).toHaveBeenCalledWith("Message")

    it 'passes when the condition is a string', ->
      Module.assert '123', 'Message'
      expect(alert).not.toHaveBeenCalled()

    it "returns false if the condition doesn't pass", ->
      expect(Module.assert(false)).toBeFalsy()

    it "returns true if the condition passes", ->
      expect(Module.assert('123')).toBeTruthy()


  describe 'jQuery Integration', ->

    beforeEach ->
      spyOn window, 'alert'

    it 'works', ->
      $('#test #module_container').module(TestModule)
      expect(alert).not.toHaveBeenCalled()

    it 'returns the created instance', ->
      result = $('#test #module_container').module(Module)
      expect(result).toBeDefined()
      expect(typeof result).toEqual('object')

    it 'returns an error if the given parameter is not a class', ->
      $('#test').module()
      expect(alert).toHaveBeenCalled()

    it 'returns an error if the jQuery object is empty.', ->
      $('#test #zonk').module(Module)
      expect(alert).toHaveBeenCalled()


  describe 'event handling', ->

    # Variables that should be accessible in both the beforeEach block and the tests.
    module = null
    mockContainer = null

    beforeEach ->
      mockContainer = $('#test #module_container')
      module = new TestModule(mockContainer)
      spyOn window, 'alert'


    describe 'bind_event', ->

      beforeEach ->
        spyOn mockContainer, 'bind'

      it 'binds the given custom jQuery event type and the given callback to the container', ->
        myCallback = ->
        module.bind_event 'myEventType', myCallback
        expect(mockContainer.bind).toHaveBeenCalledWith('myEventType', myCallback)
        expect(window.alert).not.toHaveBeenCalled()

      it "throws an error if no parameters are given", ->
        module.bind_event()
        expect(window.alert).toHaveBeenCalled()
        expect(mockContainer.bind).not.toHaveBeenCalled()

      it "throws an error if the given event type doesn't exist", ->
        module.bind_event undefined, ->
        expect(window.alert).toHaveBeenCalled()
        expect(mockContainer.bind).not.toHaveBeenCalled()

      it 'throws an error if the given event type is not a string', ->
        module.bind_event {}, ->
        expect(window.alert).toHaveBeenCalled()
        expect(mockContainer.bind).not.toHaveBeenCalled()

      it "throws an error if the given callback doesn't exist", ->
        module.bind_event '123'
        expect(window.alert).toHaveBeenCalled()
        expect(mockContainer.bind).not.toHaveBeenCalled()

      it 'throws an error if the given callback is not a function', ->
        module.bind_event '123', {}
        expect(window.alert).toHaveBeenCalled()
        expect(mockContainer.bind).not.toHaveBeenCalled()


    describe 'fire_event', ->

      beforeEach ->
        spyOn mockContainer, 'trigger'

      it 'triggers a custom jQuery event with the given event type on the container object', ->
        module.fire_event 'event type', 'event data'
        expect(mockContainer.trigger).toHaveBeenCalledWith('event type', 'event data')

      describe 'when no payload is given', ->
        it 'provides an empty object as payload', ->
          module.fire_event 'event type'
          expect(mockContainer.trigger).toHaveBeenCalled()
          expect(mockContainer.trigger.argsForCall[0][1]).toEqual({})

        it "doesn't change the original payload variable", ->
          data = undefined
          module.fire_event 'event type', data
          expect(data).toBeUndefined

      it 'provides 0 as payload if 0 is given', ->
        module.fire_event 'event type', 0
        expect(mockContainer.trigger).toHaveBeenCalled()
        expect(mockContainer.trigger.argsForCall[0][1]).toEqual(0)

      it 'throws an error if the given event type is not a string', ->
        module.fire_event {}
        expect(mockContainer.trigger).not.toHaveBeenCalled()
        expect(window.alert).toHaveBeenCalled()


    describe 'global events', ->

      # Variables that should be accessible in both the beforeEach block and the tests.
      mockGlobalContainer = null

      beforeEach ->
        mockGlobalContainer = $('#test #module_container')
        spyOn(Module, 'global_event_container').andReturn(mockGlobalContainer)

      describe 'bind_global_event', ->

        beforeEach ->
          spyOn mockGlobalContainer, 'bind'

        it 'binds the given event type and callback method to the global event container', ->
          callback = ->
          Module.bind_global_event '123', callback
          expect(mockGlobalContainer.bind).toHaveBeenCalledWith('123', callback)

        it "throws an error if no parameters are given", ->
          Module.bind_global_event()
          expect(window.alert).toHaveBeenCalled()
          expect(mockGlobalContainer.bind).not.toHaveBeenCalled()

        it "throws an error if the given event type doesn't exist", ->
          Module.bind_global_event undefined, ->
          expect(window.alert).toHaveBeenCalled()
          expect(mockGlobalContainer.bind).not.toHaveBeenCalled()

        it 'throws an error if the given event type is not a string', ->
          Module.bind_global_event {}, ->
          expect(window.alert).toHaveBeenCalled()
          expect(mockGlobalContainer.bind).not.toHaveBeenCalled()

        it "throws an error if the given callback doesn't exist", ->
          Module.bind_global_event '123'
          expect(window.alert).toHaveBeenCalled()
          expect(mockGlobalContainer.bind).not.toHaveBeenCalled()

        it 'throws an error if the given callback is not a function', ->
          Module.bind_global_event '123', {}
          expect(window.alert).toHaveBeenCalled()
          expect(mockGlobalContainer.bind).not.toHaveBeenCalled()


      describe 'fire_global_event', ->

        beforeEach ->
          spyOn mockGlobalContainer, 'trigger'

        it 'triggers a custom jQuery event with the given event type on the global event container object', ->
          Module.fire_global_event 'event type', 'event data'
          expect(mockGlobalContainer.trigger).toHaveBeenCalledWith('event type', 'event data')

        describe 'when no payload is given', ->
          it 'provides an empty object as payload', ->
            Module.fire_global_event 'event type'
            expect(mockGlobalContainer.trigger).toHaveBeenCalled()
            expect(mockGlobalContainer.trigger.argsForCall[0][1]).toEqual({})

          it "doesn't change the original payload variable", ->
            data = undefined
            Module.fire_global_event 'event type', data
            expect(data).toBeUndefined

        it 'provides 0 as payload if 0 is given', ->
          Module.fire_global_event 'event type', 0
          expect(mockGlobalContainer.trigger).toHaveBeenCalled()
          expect(mockGlobalContainer.trigger.argsForCall[0][1]).toEqual(0)

        it 'throws an error if the given event type is not a string', ->
          Module.fire_global_event {}
          expect(mockGlobalContainer.trigger).not.toHaveBeenCalled()
          expect(window.alert).toHaveBeenCalled()

  describe 'mixins', ->

    myMixin = instance = recordedSelf = Test = null
    myMixin =
      constructor: -> recordedSelf = @
      method1: ->
      method2: ->

    beforeEach ->
      class Test extends Module
        @mixin myMixin



    it 'adds all methods from the mixin object to the class prototype', ->
      instance = new Test('testing')
      expect(typeof instance.method1).toBe("function")


    it 'calls the proper mixin method when calling from the implementing module', ->
      spyOn(myMixin, 'method1')
      spyOn(myMixin, 'method2')
      instance = new Test('testing')
      instance.method1()
      expect(myMixin.method1).toHaveBeenCalled()
      expect(myMixin.method2).not.toHaveBeenCalled()

    it 'calls the mixin with the proper paramaters', ->
      spyOn(myMixin, 'method1')
      instance = new Test('testing')
      instance.method1("arg1", "arg2")
      expect(myMixin.method1).toHaveBeenCalledWith("arg1", "arg2")


    it 'calls the constructor of the mixin', ->
      spyOn(myMixin, 'constructor')
      instance = new Test('testing')
      expect(myMixin.constructor).toHaveBeenCalled()


    it 'calls the constructor with the this pointing to the instance', ->
      instance = new Test('testing')
      expect(recordedSelf).toBe(instance)

    xit 'provides arguments to the @mixin method to the mixin constructor'
