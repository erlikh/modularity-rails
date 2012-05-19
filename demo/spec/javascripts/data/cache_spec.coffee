#= require spec_helper
#= require modularity/data/cache


describe 'Cache', ->
  
  cache = null
  beforeEach ->
    cache = new modularity.Cache()


  describe 'constructor', ->

    it 'initializes with an empty cache', ->
      cache.cache.should.eql({})


  describe 'add', ->

    it 'stores the given data in the cache', ->
      cache.add 'foo', 'bar'
      cache.cache.should.eql({'foo': 'bar'})

    it 'overwrites existing entries', ->
      cache.cache = {'foo', 'bar'}
      cache.add 'foo', 'new'
      (cache.cache['foo']).should.be.equal('new')


  describe 'delete', ->

    it 'removes the entry with the given key from the chache', ->
      cache.add 'foo', 'bar'
      cache.delete 'foo'
      expect(cache.get('foo')).to.be.undefined
      cache.length().should.equal 0

    it 'only removes the given data and leaves the rest of the cache alone', ->
      cache.add 1, 'one'
      cache.add 2, 'two'
      cache.delete 1
      expect(cache.get(1)).to.be.undefined
      expect(cache.get(2)).to.equal 'two'
      cache.length().should.equal 1


  describe 'get', ->

    it "returns undefined if the entry doesn't exist", ->
      expect(cache.get('zonk')).to.be.undefined

    it "returns the entry if it exists", ->
      cache.add 'foo', 'bar'
      cache.get('foo').should.equal('bar')


  describe 'getMany', ->

    result = null
    beforeEach ->
      cache.add('one', 1)
      cache.add('two', 2)
      result = cache.getMany ['one', 'three']

    it "returns the values that exist in the 'found' structure", ->
      result.found.should.eql({'one': 1})

    it "returns the values that don't exist in the 'missing' structure", ->
      result.missing.should.eql(['three'])


  describe 'length', ->

    it 'returns 0 for empty cache', ->
      cache.length().should.equal 0

    it 'returns the number of objects in the cache', ->
      cache.add('foo', 'bar')
      cache.add('fooz', 'baz')
      cache.length().should.equal(2)


  describe 'replaceAll', ->

    it 'replaces the whole cache with the given data', ->
      cache.add 'one', 1
      cache.replaceAll {'one': 2, two: 3}
      cache.length().should.equal(2)
      cache.get('one').should.equal(2)
      cache.get('two').should.equal(3)

    describe 'with 2 parameters', ->

      it 'parses the given array, and indexes on the given key', ->
        ten = {id: 10, value: 'ten'}
        twelve = {id: 12, value: 'twelve'}

        cache.replaceAll [ten, twelve], 'id'

        cache.length().should.equal 2
        cache.get(10).should.equal ten
        cache.get(12).should.equal twelve

