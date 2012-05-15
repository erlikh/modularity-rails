#= require spec_helper
#= require modularity/modules/counter_button


describe 'CounterButton', ->

  beforeEach ->
    template 'button'

  describe 'standard button functionality', ->

    describe 'manual clicks', ->

      it 'fires when clicking on the container directly', ->
        button = new modularity.CounterButton('#konacha #button1')
        button.bind_event('clicked', (spy = sinon.spy()))

        button.container.click()

        spy.should.have.been.calledOnce


      it 'fires when clicking embedded elements of the button', ->
        button = new modularity.CounterButton('#konacha #button2')
        button.bind_event('clicked', (spy = sinon.spy()))

        button.container.find('.embedded').click()

        spy.should.have.been.calledOnce

    describe 'programmatic clicks', ->

      it 'programmatically clicks the button', ->
        button = new modularity.CounterButton('#konacha #button2')
        spy = sinon.spy()
        button.bind_event('clicked', spy)

        button.click()

        spy.should.have.been.called
        
  describe 'CounterButton specific functionality', ->

    it 'provides the click counter as the event payload', ->
      button = new modularity.CounterButton('#konacha #button1')
      button.bind_event('clicked', (spy = sinon.spy()))

      button.container.click()
      button.container.click()
      button.container.click()

      spy.should.have.been.calledThrice
      spy.args[0][1].should.equal 1
      spy.args[1][1].should.equal 2
      spy.args[2][1].should.equal 3


