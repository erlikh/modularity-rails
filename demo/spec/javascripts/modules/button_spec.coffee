#= require spec_helper
#= require modularity/modules/button


describe 'Button', ->
  
  beforeEach ->
    template 'button'

  describe 'manual clicks', ->

    it 'fires when clicking on the container directly', ->
      button = new modularity.Button($('#konacha #button1'))
      button.bind_event('clicked', (spy = sinon.spy()))

      button.container.click()

      spy.should.have.been.calledOnce


    it 'fires when clicking embedded elements of the button', ->
      button = new modularity.Button($('#konacha #button2'))
      button.bind_event('clicked', (spy = sinon.spy()))

      button.container.find('.embedded').click()

      spy.should.have.been.calledOnce


  describe 'programmatic clicks', ->

    it 'programmatically clicks the button', ->
      button = new modularity.Button($('#konacha #button2'))
      spy = sinon.spy()
      button.bind_event('clicked', spy)

      button.click()

      spy.should.have.been.called
