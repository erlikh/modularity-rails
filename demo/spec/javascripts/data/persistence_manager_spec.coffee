#= require spec_helper
#= require modularity/data/persistence_manager
#= require jquery


describe 'PersistenceManager', ->
  
  # Global variables for testing.
  persistence_manager = null
  entry_1 = {id: 1, value: 'one'}
  entry_2 = {id: 2, value: 'two'}

  beforeEach ->
    persistence_manager = new modularity.PersistenceManager {url: '/users'}


  describe 'constructor', ->

    it 'initializes an empty server data cache', ->
      persistence_manager.server_data.length().should.equal 0

    it 'initializes an empty client data cache', ->
      persistence_manager.client_data.length().should.eql 0

    it 'stores the given base url', ->
      persistence_manager.base_url.should.equal '/users'

    it 'stores the given index key', ->
      persistence_manager = new modularity.PersistenceManager {key: 'my_key', url: '/users'}
      persistence_manager.key.should.equal 'my_key'

    it "uses 'id' as the default if no key is given", ->
      persistence_manager.key.should.equal 'id'


  describe 'add_all', ->

    it 'adds the given data to the server_data cache', ->
      spy = sinon.spy persistence_manager.server_data, 'add_all'
      data = [{id: 1}, {id: 2}]
      persistence_manager.add_all data
      spy.should.have.been.calledOnce


  describe 'create', ->
    new_obj = {value: 'foo'}

    beforeEach ->
      sinon.stub(jQuery, 'ajax').yieldsTo('success', entry_2)
      
    afterEach ->
      jQuery.ajax.restore()

    it 'makes an ajax POST request to the CREATE url on the server', ->
      persistence_manager.create new_obj, ->
      jQuery.ajax.should.have.been.calledOnce
      args = jQuery.ajax.args[0][0]
      args.url.should.equal '/users.json'
      args.type.should.equal 'POST'

    it 'sends the object as payload', ->
      persistence_manager.create new_obj, ->
      args = jQuery.ajax.args[0][0]
      args.data.should.equal new_obj

    it "doesn't updates the server cache immediately because the object doesn't have an id", ->
      persistence_manager.create new_obj, ->
      expect(persistence_manager.server_data.get(1)).to.be.undefined

    it 'updates the server cache with the server data when the call returns', (done) ->
      persistence_manager.create {value: 'bar'}, (server_obj) ->
        persistence_manager.server_data.get(server_obj.id).should.equal entry_2
        done()

    it 'calls the given callback when done', (done) ->
      persistence_manager.create new_obj, ->
        done()


  describe 'delete', ->

    beforeEach ->
      sinon.stub(jQuery, 'ajax').yieldsTo('success')

    afterEach ->
      jQuery.ajax.restore()

    it 'makes an ajax DELETE request to the item url on the server', ->
      persistence_manager.delete entry_1
      jQuery.ajax.should.have.been.calledOnce
      args = jQuery.ajax.args[0][0]
      args.url.should.equal '/users/1.json'
      args.type.should.equal 'DELETE'

    it 'removes the object from the client and server cache', ->
      persistence_manager.server_data.add entry_1
      persistence_manager.client_data.add entry_1
      persistence_manager.delete entry_1
      persistence_manager.server_data.length().should.equal 0
      persistence_manager.client_data.length().should.equal 0

    it 'calls the given callback when done', (done) ->
      persistence_manager.delete entry_1, ->
        done()


  describe 'entry_url', ->

    it 'returns the url to access a single entry', ->
      persistence_manager.entry_url(entry_1).should.equal '/users/1.json'


  describe 'load_all', ->

    loading_done_callback = null
    beforeEach ->
      sinon.stub(jQuery, 'ajax').yieldsTo('success', [entry_1, entry_2])
      loading_done_callback = sinon.spy()
      persistence_manager.load_all loading_done_callback, {'q': 'foo'},

    afterEach ->
      jQuery.ajax.restore()
      
    it 'makes a request to the INDEX action of the server', ->
      jQuery.ajax.should.have.been.calledOnce
      jQuery.ajax.args[0][0].url.should.equal '/users.json'

    it 'provides the given data as parameters to the request', ->
      jQuery.ajax.args[0][0].data.should.eql {'q': 'foo'}

    it 'fills the server cache with the response data', ->
      persistence_manager.server_data.length().should.eql 2
      persistence_manager.server_data.get(1).should.eql entry_1
      persistence_manager.server_data.get(2).should.eql entry_2

    it 'calls the given callback method when the data is available', ->
      loading_done_callback.should.have.been.calledOnce


  describe 'load_local', ->

    describe 'entry exists in client data cache', ->
      it 'returns the entry from the @client_data cache if it exists there', ->
        persistence_manager.client_data.add entry_1
        result = persistence_manager.load_local 1
        result.should.equal entry_1

    describe 'entry exists in server data cache', ->

      beforeEach ->
        persistence_manager.server_data.add entry_1

      it 'adds the entry to the client data cache', ->
        persistence_manager.load_local 1
        persistence_manager.client_data.length().should.equal 1
        persistence_manager.client_data.get(1).should.eql entry_1

      it 'returns the entry from the client data cache', ->
        result = persistence_manager.load_local 1
        client_cache_entry = persistence_manager.client_data.get 1
        result.should.equal client_cache_entry

      it 'returns a different hash than the server data, so that the user can make changes to it', ->
        result = persistence_manager.load_local 1
        server_cache_entry = persistence_manager.server_data.get 1
        result.should.not.equal server_cache_entry

    describe "entry doesn't exist in any cache", ->

      it 'returns undefined', ->
        expect(persistence_manager.load_local(1)).to.be.undefined


  describe 'load_many', ->

    describe 'all entries exists in the cache', ->
      it 'returns the entries immediately', (done) ->
        persistence_manager.add_all [entry_1, entry_2]
        persistence_manager.load_many [1,2], (entries) ->
          entries.length.should.equal 2
          entries[0].should.eql entry_1
          entries[1].should.eql entry_2
          done()


  describe 'load', ->

    describe 'entry exists in client data cache', ->
      it 'returns the entry from the @client_data cache if it exists there', (done) ->
        persistence_manager.client_data.add entry_1
        persistence_manager.load 1, (entry) ->
          entry.should.equal entry_1
          done()

    describe 'entry exists in server data cache', ->

      beforeEach ->
        persistence_manager.server_data.add entry_1

      it 'adds the entry to the client data cache', (done) ->
        persistence_manager.load 1, ->
          persistence_manager.client_data.length().should.equal 1
          persistence_manager.client_data.get(1).should.eql entry_1
          done()

      it 'returns the entry from the client data cache', (done) ->
        persistence_manager.load 1, (entry) ->
          client_cache_entry = persistence_manager.client_data.get 1
          entry.should.equal client_cache_entry
          done()

      it 'returns a different hash than the server data, so that the user can make changes to it', (done) ->
        persistence_manager.load 1, (entry) ->
          server_cache_entry = persistence_manager.server_data.get 1

          entry.should.not.equal server_cache_entry
          done()


    describe "entry doesn't exist on the client at all", ->
      
      beforeEach ->
        sinon.stub(jQuery, 'ajax').yieldsTo('success', entry_1)

      afterEach ->
        jQuery.ajax.restore()

      it "retrieves the entry from the server", (done) ->
        persistence_manager.load 1, ->
          jQuery.ajax.should.have.been.calledOnce
          done()


      it 'stores the entry in the server cache', (done) ->
        persistence_manager.load 1, ->
          persistence_manager.server_data.length().should.equal 1
          persistence_manager.server_data.get(1).should.equal entry_1
          done()

      it 'stores a replica of the entry in the client cache', (done) ->
        persistence_manager.load 1, ->
          persistence_manager.client_data.get(1).should.not.equal entry_1
          persistence_manager.client_data.get(1).should.eql entry_1
          done()

      it 'returns the client replica', (done) ->
        persistence_manager.load 1, (entry) ->
          persistence_manager.client_data.get(1).should.equal entry
          persistence_manager.server_data.get(1).should.not.equal entry
          done()


  describe 'save', ->

    describe 'for unsaved objects', ->
      it "calls the 'create' action", ->
        sinon.stub persistence_manager, 'create'
        persistence_manager.save {value: 'foo'}, ->
        persistence_manager.create.should.have.been.calledOnce

    describe 'for objects from the server', ->
      it "calls the 'update' action", ->
        sinon.stub persistence_manager, 'update'
        persistence_manager.save entry_1, ->
        persistence_manager.update.should.have.been.calledOnce


  describe 'update', ->

    beforeEach ->
      sinon.stub(jQuery, 'ajax').yieldsTo('success', entry_2)
      server_entry = {id: 1, title: 'server title', desc: 'server desc'}
      persistence_manager.server_data.add server_entry
      
    afterEach ->
      jQuery.ajax.restore()

    it 'makes an ajax PUT request to the UPDATE url on the server', ->
      persistence_manager.update entry_1, ->
      jQuery.ajax.should.have.been.calledOnce
      args = jQuery.ajax.args[0][0]
      args.url.should.equal '/users/1.json'
      args.type.should.equal 'PUT'

    it 'sends only updated colums of the object as payload', (done) ->
      persistence_manager.load 1, (client_entry) ->
        client_entry.title = 'client title'

        persistence_manager.update client_entry


        args = jQuery.ajax.args[0][0]
        args.data.should.eql {id: 1, title: 'client title'}
        done()

    it "doesn't perform the call if nothing is changed", (done) ->
      persistence_manager.load 1, (client_entry) ->
        persistence_manager.update client_entry
        jQuery.ajax.should.not.have.been.called
        done()

    it 'updates the server cache immediately with the given object', ->
      persistence_manager.update entry_1, ->
      persistence_manager.server_data.get(1).should.equal entry_1

    it 'updates the server cache with the server object when done', (done) ->
      persistence_manager.update entry_1, (server_obj) ->
        persistence_manager.server_data.get(2).should.equal entry_2
        done()

    it 'calls the given callback when done', (done) ->
      persistence_manager.update entry_1, ->
        done()

