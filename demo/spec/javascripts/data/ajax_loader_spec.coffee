#= require spec_helper
#= require modularity/data/ajax_loader


describe 'ajax_loader', ->
  
  ajax_loader = spy = spy_get = null
  beforeEach ->
    ajax_loader = new modularity.AjaxLoader()
    spy = sinon.spy()
    spy_get = sinon.spy jQuery, 'get'

  afterEach ->
    spy_get.restore()

  describe 'get', ->

    url = "/users/4"

    describe 'the data has already been loaded', ->

      it 'calls the callback with the cached data', ->
        ajax_loader.cache.add url, "my data"

        ajax_loader.get(url, spy)

        spy.should.have.been.called
        spy.should.have.been.calledWith "my data"


    describe 'the request is already in progress', ->

      beforeEach ->
        ajax_loader.cache.cache[url] = [spy]


      it 'adds the callback to the callback array', ->
        ajax_loader.cache.get(url).should.have.length 1
        ajax_loader.cache.get(url)[0].should.equal spy


      it 'returns without calling the callback', ->
        spy.should.not.have.been.called


      it 'does not make another ajax request', ->
        jQuery.get.should.not.have.been.called


    describe 'first time request', ->
      
      beforeEach ->
        ajax_loader.get url, spy

      it 'makes an ajax request', ->
        jQuery.get.should.have.been.called


      it 'saves the callback for later', ->
        ajax_loader.cache.get(url).should.have.length 1
        ajax_loader.cache.get(url)[0].should.equal spy

      it 'returns without calling the callback', ->
        spy.should.not.have.been.called

    
    describe 'ajax request successful', ->

      beforeEach ->
        jquery_callback = null
        jQuery.get = (url, callback) -> jquery_callback = callback
        ajax_loader.get url, spy
        jquery_callback('result')

      it 'calls the given callbacks', ->
        spy.should.have.been.calledWith 'result'

      it 'replaces the cache callbacks with returned data', ->
        ajax_loader.cache.get(url).should.equal 'result'
