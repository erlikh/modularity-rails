#= require spec_helper

describe 'test environment setup', ->

  it 'loading libraries', ->
    load_modularity()
    loadCS "/vendor/assets/javascripts/tools/ajax_loader.coffee"


describe 'ajax_loader', ->
  
  describe 'get', ->
    spy = null
    beforeEach ->
      spyOn(jQuery, 'get')
      spy = jasmine.createSpy()
      modularity.loader.cache = {}

    url = "user/4"

    describe 'the data has already been loaded', ->
      it 'calls the callback with the cached data', ->
        spy = jasmine.createSpy()
        url = "/users/4"

        modularity.loader.cache[url] = "my data"
        modularity.loader.get(url, spy)

        expect(spy).toHaveBeenCalled()
        expect(spy.argsForCall[0][0]).toEqual("my data")


    describe 'the request is already in progress', ->

      beforeEach ->
        modularity.loader.cache[url] = []
        modularity.loader.get(url, spy)


      it 'adds the callback to the callback array', ->
        expect(modularity.loader.cache[url].length).toEqual(1)
        expect(modularity.loader.cache[url][0]).toEqual(spy)


      it 'returns without calling the callback', ->
        expect(spy).not.toHaveBeenCalled()


      it 'does not make another ajax request', ->
        expect(jQuery.get).not.toHaveBeenCalled()



    describe 'first time request', ->
      
      beforeEach ->
        modularity.loader.get(url, spy)

      it 'makes an ajax request', ->
        expect(jQuery.get).toHaveBeenCalled()


      it 'saves the callback for later', ->
        expect(modularity.loader.cache[url].length).toEqual(1)
        expect(modularity.loader.cache[url][0]).toEqual(spy)

      it 'returns without calling the callback', ->
        expect(spy).not.toHaveBeenCalled()


    
    describe 'ajax request successful', ->

      beforeEach ->
        jquery_callback = null
        jQuery.get = (url, callback) -> jquery_callback = callback
        modularity.loader.get url, spy
        jquery_callback('result')

      it 'calls the given callbacks', ->
        expect(spy).toHaveBeenCalled()
        expect(spy.argsForCall[0][0]).toEqual('result')

      it 'replaces the cache callbacks with returned data', ->
        expect(modularity.loader.cache[url]).toEqual('result')
