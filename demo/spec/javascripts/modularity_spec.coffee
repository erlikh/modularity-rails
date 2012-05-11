#= require spec_helper

class window.TestModule extends modularity.Module


describe 'modularity', ->

  alert_stub = null
  beforeEach ->
    template 'modularity'
    alert_stub = sinon.stub window, 'alert'

  afterEach ->
    alert_stub.restore()


  describe 'constructor', ->

    it "is defined on the 'window' object", ->
      modularity.Module.should.not.be.undefined

    it 'shows an error if no container is given', ->
      new TestModule()
      window.alert.should.have.been.called

    it 'tries to load the DOM if the given container is a string', ->
      new TestModule('#konacha #module_container')
      window.alert.should.not.have.been.called

    it 'shows an error if the container is not a jQuery object', ->
      new TestModule({})
      window.alert.should.have.been.called

    it 'shows an error if the container is an empty jQuery object', ->
      new TestModule($('#konacha .zonk'))
      window.alert.should.have.been.called

    it 'shows an error if the container has more than one elements', ->
      new TestModule($('#konacha .double'))
      window.alert.should.have.been.called

    it "allows to provide 'testing' in tests", ->
      new TestModule('testing')
      window.alert.should.not.have.been.called


  describe 'assert', ->

    it 'shows an alert with the given message if the given condition is false', ->
      modularity.assert false, 'Message'
      window.alert.should.have.been.calledWith "Message"

    it 'fails when the condition is null', ->
      modularity.assert null, 'Message'
      window.alert.should.have.been.calledWith "Message"

    it 'fails when the condition is undefined', ->
      modularity.assert undefined, 'Message'
      window.alert.should.have.been.calledWith "Message"

    it 'fails when the condition is an empty array', ->
      modularity.assert [], 'Message'
      window.alert.should.have.been.calledWith "Message"

    it 'fails when the condition is an empty string', ->
      modularity.assert '', 'Message'
      window.alert.should.have.been.calledWith "Message"

    it 'passes when the condition is a string', ->
      modularity.assert '123', 'Message'
      window.alert.should.not.have.been.called

    it "returns false if the condition doesn't pass", ->
      modularity.assert(false).should.be.false

    it "returns true if the condition passes", ->
      modularity.assert('123').should.be.true


  describe 'jQuery Integration', ->

    it 'works', ->
      $('#konacha #module_container').module(TestModule)
      window.alert.should.not.have.been.called

    it 'returns the created instance', ->
      result = $('#konacha #module_container').module(modularity.Module)
      result.should.exist
      result.should.be.instanceOf modularity.Module

    it 'returns an error if the given parameter is not a class', ->
      $('#konacha').module()
      window.alert.should.have.been.called

    it 'returns an error if the jQuery object is empty.', ->
      $('#konacha #zonk').module(modularity.Module)
      window.alert.should.have.been.called


  describe 'event handling', ->

    module = null
    mockContainer = null

    beforeEach ->
      mockContainer = $('#konacha #module_container')
      module = new TestModule(mockContainer)

    describe 'bind_event', ->

      beforeEach ->
        sinon.spy mockContainer, 'bind'

      it 'binds the given custom jQuery event type and the given callback to the container', ->
        myCallback = ->
        module.bind_event 'myEventType', myCallback
        mockContainer.bind.should.have.been.called
        mockContainer.bind.args[0][0].should.equal 'myEventType'
        mockContainer.bind.args[0][1].should.equal myCallback
        window.alert.should.not.have.been.called

      it "throws an error if no parameters are given", ->
        module.bind_event()
        window.alert.should.have.been.called
        mockContainer.bind.should.not.have.been.called

      it "throws an error if the given event type doesn't exist", ->
        module.bind_event undefined, ->
        window.alert.should.have.been.called
        mockContainer.bind.should.not.have.been.called

      it 'throws an error if the given event type is not a string', ->
        module.bind_event {}, ->
        window.alert.should.have.been.called
        mockContainer.bind.should.not.have.been.called

      it "throws an error if the given callback doesn't exist", ->
        module.bind_event '123'
        window.alert.should.have.been.called
        mockContainer.bind.should.not.have.been.called

      it 'throws an error if the given callback is not a function', ->
        module.bind_event '123', {}
        window.alert.should.have.been.called
        mockContainer.bind.should.not.have.been.called


    describe 'fire_event', ->

      beforeEach ->
        sinon.spy mockContainer, 'trigger'

      it 'triggers a custom jQuery event with the given event type on the container object', ->
        module.fire_event 'event type', 'event data'
        mockContainer.trigger.should.have.been.called
        mockContainer.trigger.args[0][0].should.equal 'event type'
        mockContainer.trigger.args[0][1].should.equal 'event data'

      describe 'when no payload is given', ->
        it 'provides an empty object as payload', ->
          module.fire_event 'event type'
          mockContainer.trigger.should.have.been.called
          mockContainer.trigger.args[0][1].should.eql({})

        it "doesn't change the original payload variable", ->
          data = undefined
          module.fire_event 'event type', data
          expect(data).to.be.undefined

      it 'provides 0 as payload if 0 is given', ->
        module.fire_event 'event type', 0
        mockContainer.trigger.should.have.been.called
        mockContainer.trigger.args[0][1].should.equal(0)

      it 'throws an error if the given event type is not a string', ->
        module.fire_event {}
        mockContainer.trigger.should.not.have.been.called
        window.alert.should.have.been.called


    describe 'global events', ->

      mockGlobalContainer = null
      beforeEach ->
        mockGlobalContainer = $('#test #module_container')
        sinon.stub(modularity, 'global_event_container').returns(mockGlobalContainer)

      afterEach ->
        modularity.global_event_container.restore()


      describe 'bind_global_event', ->

        beforeEach ->
          sinon.spy mockGlobalContainer, 'bind'

        afterEach ->
          mockGlobalContainer.bind.restore()

        it 'binds the given event type and callback method to the global event container', ->
          callback = ->
          modularity.bind_global_event '123', callback
          mockGlobalContainer.bind.should.have.been.called
          mockGlobalContainer.bind.args[0][0].should.equal '123'
          mockGlobalContainer.bind.args[0][1].should.equal callback

        it "throws an error if no parameters are given", ->
          modularity.bind_global_event()
          window.alert.should.have.been.called
          mockGlobalContainer.bind.should.not.have.been.called

        it "throws an error if the given event type doesn't exist", ->
          modularity.bind_global_event undefined, ->
          window.alert.should.have.been.called
          mockGlobalContainer.bind.should.not.have.been.called

        it 'throws an error if the given event type is not a string', ->
          modularity.bind_global_event {}, ->
          window.alert.should.have.been.called
          mockGlobalContainer.bind.should.not.have.been.called

        it "throws an error if the given callback doesn't exist", ->
          modularity.bind_global_event '123'
          window.alert.should.have.been.called
          mockGlobalContainer.bind.should.not.have.been.called

        it 'throws an error if the given callback is not a function', ->
          modularity.bind_global_event '123', {}
          window.alert.should.have.been.called
          mockGlobalContainer.bind.should.not.have.been.called


      describe 'fire_global_event', ->

        beforeEach ->
          sinon.spy mockGlobalContainer, 'trigger'

        afterEach ->
          mockGlobalContainer.trigger.restore()


        it 'triggers a custom jQuery event with the given event type on the global event container object', ->
          modularity.fire_global_event 'event type', 'event data'
          mockGlobalContainer.trigger.should.have.been.called
          mockGlobalContainer.trigger.args[0][0].should.equal 'event type'
          mockGlobalContainer.trigger.args[0][1].should.equal 'event data'

        describe 'when no payload is given', ->
          it 'provides an empty object as payload', ->
            modularity.fire_global_event 'event type'
            mockGlobalContainer.trigger.should.have.been.called
            mockGlobalContainer.trigger.args[0][1].should.eql({})

          it "doesn't change the original payload variable", ->
            data = undefined
            modularity.fire_global_event 'event type', data
            expect(data).to.equal.undefined

        it 'provides 0 as payload if 0 is given', ->
          modularity.fire_global_event 'event type', 0
          mockGlobalContainer.trigger.should.have.been.called
          mockGlobalContainer.trigger.args[0][1].should.equal(0)

        it 'throws an error if the given event type is not a string', ->
          modularity.fire_global_event {}
          mockGlobalContainer.trigger.should.not.have.been.called
          window.alert.should.have.been.called


  describe 'mixins', ->

    myMixin = instance = recordedSelf = Test = null
    myMixin =
      constructor: -> recordedSelf = @
      method1: ->
      method2: ->

    beforeEach ->
      class Test extends modularity.Module
        @mixin myMixin


    it 'adds all methods from the mixin object to the class prototype', ->
      instance = new Test('testing')
      instance.method1.should.be.a("function")


    it 'calls the proper mixin method when calling from the implementing module', ->
      sinon.spy myMixin, 'method1'
      sinon.spy myMixin, 'method2'
      instance = new Test('testing')
      instance.method1()
      myMixin.method1.should.have.been.called
      myMixin.method2.should.not.have.been.called
      myMixin.method1.restore()
      myMixin.method2.restore()

    it 'calls the mixin with the proper paramaters', ->
      sinon.spy myMixin, 'method1'
      instance = new Test('testing')
      instance.method1("arg1", "arg2")
      myMixin.method1.should.have.been.calledWith("arg1", "arg2")
      myMixin.method1.restore()


    it 'calls the constructor of the mixin', ->
      sinon.spy myMixin, 'constructor'
      instance = new Test('testing')
      myMixin.constructor.should.have.been.called


    it 'calls the constructor with the this object pointing to the instance', ->
      instance = new Test('testing')
      recordedSelf.should.equal instance

    it "can handle mixins that don't define a constructor"

    it "shows an error message if the given mixin is undefined"

    it 'provides arguments to the @mixin method to the mixin constructor'
