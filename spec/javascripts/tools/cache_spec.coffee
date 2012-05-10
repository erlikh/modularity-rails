#= require spec_helper

describe 'test environment setup', ->

  it 'loading libraries', ->
    load_modularity()
    loadCS "/vendor/assets/javascripts/tools/cache.coffee"


describe 'Cache', ->
  
  cache = null
  beforeEach ->
    cache = new modularity.Cache()


  describe 'constructor', ->

    it 'initializes with an empty cache', ->
      expect(cache.cache).toEqual({})


  describe 'add', ->

    it 'stores the given data in the cache', ->
      cache.add('foo', 'bar')
      expect(cache.cache).toEqual({'foo': 'bar'})

    it 'overwrites existing entries', ->
      cache.cache = {'foo', 'bar'}
      cache.add 'foo', 'new'
      expect(cache.cache['foo']).toBe('new')


  describe 'get', ->

    it "returns undefined if the entry doesn't exist", ->
      expect(cache.get('zonk')).toBe(undefined)

    it "returns the entry if it exists", ->
      cache.add 'foo', 'bar'
      expect(cache.get('foo')).toBe('bar')


  describe 'getMany', ->

    result = null
    beforeEach ->
      cache.add('one', 1)
      cache.add('two', 2)
      result = cache.getMany ['one', 'three']

    it "returns the values that exist in the 'found' structure", ->
      expect(result.found).toEqual({'one': 1})

    it "returns the values that don't exist in the 'missing' structure", ->
      expect(result.missing).toEqual(['three'])


  describe 'length', ->

    it 'returns 0 for empty cache', ->
      expect(cache.length()).toBe 0

    it 'returns the number of objects in the cache', ->
      cache.add('foo', 'bar')
      cache.add('fooz', 'baz')
      expect(cache.length()).toBe(2)


  describe 'replaceAll', ->

    it 'replaces the whole cache with the given data', ->
      cache.add 'one', 1
      cache.replaceAll {'one': 2, two: 3}
      expect(cache.length()).toBe(2)
      expect(cache.get('one')).toBe(2)
      expect(cache.get('two')).toBe(3)

