#= require spec_helper
#= require modularity/tools/object_tools


describe 'clone', ->

  clone = null
  entry_1 = {id: 1, value: 'one'}
  beforeEach ->
    clone = modularity.clone_hash entry_1

  it 'returns an object that has the same properties as the given object', ->
    clone.id.should.equal 1
    clone.value.should.equal 'one'

  it 'returns an object that can be changed independently from the given object', ->
    clone.id = 2
    clone.value = 'two'
    entry_1.id.should == 1
    entry_1.value.should == 'one'


describe 'object_tools', ->

  describe 'object_diff', ->
    obj_1 = {title: 'title 1', value: 'value 1'}
    obj_2 = {title: 'title 2', value: 'value 1'}
    obj_1b = {title: 'title 1', value: 'value 1'}

    it 'returns a new object that contains only the changed attributes', ->
      modularity.object_diff(obj_1, obj_2).should.eql {title: 'title 2'}

    it 'returns an empty object if the two objects are equal', ->
      modularity.object_diff(obj_1, obj_1b).should.eql {}


  describe 'object_length', ->

    it 'returns the number of attributes of the given object', ->
      obj_1 = {1: 'one'}
      obj_2 = {1: 'one', 2: 'two'}
      obj_3 = {1: 'one', 2: 'two', 3: 'three'}
      modularity.object_length({}).should.equal 0
      modularity.object_length(obj_1).should.equal 1
      modularity.object_length(obj_2).should.equal 2
      modularity.object_length(obj_3).should.equal 3
