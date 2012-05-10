describe 'test environment setup', ->

  it 'loading libraries', ->
    load_modularity()
    loadCS "/vendor/assets/javascripts/tools/cache.coffee"
    loadCS "/vendor/assets/javascripts/tools/ajax_loader.coffee"


describe 'ajax_loader', ->
  
  ajax_loader = null
  beforeEach ->
    ajax_loader = new modularity.AjaxLoader()

  describe 'get', ->

    url = "/users/4"
    spy = null
    beforeEach ->
      spyOn(jQuery, 'get')
      spy = jasmine.createSpy()

    describe 'the data has already been loaded', ->

      it 'calls the callback with the cached data', ->
        ajax_loader.cache.add url, "my data"

        ajax_loader.get(url, spy)

        expect(spy).toHaveBeenCalled()
        expect(spy.argsForCall[0][0]).toEqual("my data")


    describe 'the request is already in progress', ->

      beforeEach ->
        ajax_loader.cache.cache[url] = [spy]


      it 'adds the callback to the callback array', ->
        expect(ajax_loader.cache.get(url).length).toEqual(1)
        expect(ajax_loader.cache.get(url)[0]).toEqual(spy)


      it 'returns without calling the callback', ->
        expect(spy).not.toHaveBeenCalled()


      it 'does not make another ajax request', ->
        expect(jQuery.get).not.toHaveBeenCalled()



    describe 'first time request', ->
      
      beforeEach ->
        ajax_loader.get(url, spy)

      it 'makes an ajax request', ->
        expect(jQuery.get).toHaveBeenCalled()


      it 'saves the callback for later', ->
        expect(ajax_loader.cache.get(url).length).toEqual(1)
        expect(ajax_loader.cache.get(url)[0]).toEqual(spy)

      it 'returns without calling the callback', ->
        expect(spy).not.toHaveBeenCalled()


    
    describe 'ajax request successful', ->

      beforeEach ->
        jquery_callback = null
        jQuery.get = (url, callback) -> jquery_callback = callback
        ajax_loader.get url, spy
        jquery_callback('result')

      it 'calls the given callbacks', ->
        expect(spy).toHaveBeenCalled()
        expect(spy.argsForCall[0][0]).toEqual('result')

      it 'replaces the cache callbacks with returned data', ->
        expect(ajax_loader.cache.get(url)).toEqual('result')
