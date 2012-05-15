#= require spec_helper
#= require modularity/mixins/closable

# A standard closable module.
class window.ClosableModule1 extends modularity.Module
  @mixin modularity.closable


describe 'Closable', ->

  spy_alert = null
  beforeEach ->
    template 'closable'
    spy_alert = sinon.stub window, 'alert'

  afterEach ->
    spy_alert.restore()

  describe 'constructor', ->
    it 'shows an alert if there is no close button', ->
      new ClosableModule1('#konacha #closable3')
      window.alert.should.have.been.called
      window.alert.args[0][0].should.match(/close button not found/i)

    it 'shows no alert if there is a close button', ->
      new ClosableModule1('#konacha #closable1')
      window.alert.should.not.have.been.called

    it 'finds the close button div automatically', ->
      new ClosableModule1('#konacha #closable1')
      $('#konacha #closable1 .CloseButton').click()
      $('#konacha #closable1').should.have.length 0


  describe 'when clicking the close button', ->

    it "calls the closable_closing hook on the object if it exists", ->

      # A closable module with the 'closing' hook.
      class ClosableModule extends modularity.Module
        @mixin modularity.closable

        constructor: ->
          super
          @closing_hook_got_called = no

        closable_closing: => @closing_hook_got_called = yes

      module = new ClosableModule('#konacha #closable1')
      $('#konacha #closable1 .CloseButton').click()
      module.closing_hook_got_called.should.be.true


    it "calls the closable_closed hook on the object if it exists", ->

      # A closable module with the 'closed' hook.
      class ClosableModule extends modularity.Module
        @mixin modularity.closable

        constructor: ->
          super
          @closed_hook_got_called = no

        closable_closed: => @closed_hook_got_called = yes

      module = new ClosableModule('#konacha #closable1')
      $('#konacha #closable1 .CloseButton').click()
      module.closed_hook_got_called.should.be.true


    it "aborts the close operation if the closable_closing method returns false", ->

      class ClosableModuleWithHookThatReturnsFalse extends modularity.Module
        @mixin modularity.closable
        closable_closing: -> false

      module = new ClosableModuleWithHookThatReturnsFalse('#konacha #closable1')
      module.bind_event('closed', (spy = sinon.spy()))

      $('#konacha #closable1 .CloseButton').click()

      spy.should.not.have.been.called


    it 'removes the container', ->
      new ClosableModule1('#konacha #closable1')
      $('#konacha #closable1 .CloseButton').click()

      $('#konacha #closable1').should.have.length 0


    it "fires the 'closed' event", ->
      closable_module = new ClosableModule1('#konacha #closable1')
      closable_module.bind_event('closed', (spy = sinon.spy()))

      $('#konacha #closable1 .CloseButton').click()

      spy.should.have.been.calledOnce
