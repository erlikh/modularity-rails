#= require spec_helper
#= require modularity/tools/indexed_cache


describe 'IndexedCache', ->

  indexed_cache = null
  entry_1 = {id: 1, value: 'one'}
  entry_2 = {id: 2, value: 'two'}
  beforeEach ->
    indexed_cache = new modularity.IndexedCache 'id'


  describe 'constructor', ->
    
    it 'stores the given key attribute', ->
      indexed_cache.key.should == 'id'


  describe 'add', ->
    
    beforeEach ->
      indexed_cache.add entry_1

    it 'adds the given element', ->
      indexed_cache.cache.length().should.equal 1
      indexed_cache.cache.cache[1].should.eql entry_1


  describe 'add_all', ->
    it 'adds all the given elements', ->
      indexed_cache.add_all [entry_1, entry_2]
      indexed_cache.length().should.equal 2
      indexed_cache.cache.cache[1].should.eql entry_1
      indexed_cache.cache.cache[2].should.eql entry_2


  describe 'delete', ->
    it 'removes the given object from the server', ->
      indexed_cache.add entry_1
      indexed_cache.delete entry_1
      indexed_cache.length().should.equal 0

  describe 'get', ->
    it 'returns the element indexed by the given key', ->
      indexed_cache.add entry_1
      indexed_cache.get(1).should.eql entry_1

    it "returns undefined if the element doesn't exist", ->
      expect(indexed_cache.get(2)).to.be.undefined

