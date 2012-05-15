#= require spec_helper
#= require modularity/tools/array_tools

describe 'array_tools', ->

  describe 'array_unique', ->

    it 'removes duplicate entries from the given array', ->
      modularity.array_unique([1,1,2,2,3]).should.eql [1,2,3]

    it 'works with unsorted arrays', ->
      modularity.array_unique([2,3,1,2,1]).sort().should.eql [1,2,3]
