#= require spec_helper
#= require modularity/tools/data_loader
#= require jquery


describe 'DataLoader', ->
  
  # Global variables for testing.
  data_loader = null
  entry_1 = {id: 1, value: 'one'}
  entry_2 = {id: 2, value: 'two'}

  beforeEach ->
    data_loader = new modularity.DataLoader {url: '/users'}


  describe 'constructor', ->

    it 'initializes an empty server data cache', ->
      data_loader.server_data.length().should.equal 0

    it 'initializes an empty client data cache', ->
      data_loader.client_data.length().should.eql 0

    it 'stores the given base url', ->
      data_loader.url.should.equal '/users'

    it 'stores the given index key', ->
      data_loader = new modularity.DataLoader {key: 'my_key', url: '/users'}
      data_loader.key.should.equal 'my_key'

    it "uses 'id' as the default if no key is given", ->
      data_loader.key.should.equal 'id'


  describe 'clone', ->

    clone = null
    beforeEach ->
      clone = data_loader.clone entry_1

    it 'returns an object that has the same properties as the given object', ->
      clone.id.should.equal 1
      clone.value.should.equal 'one'

    it 'returns an object that can be changed independently from the given object', ->
      clone.id = 2
      clone.value = 'two'
      entry_1.id.should == 1
      entry_1.value.should == 'one'


  describe 'create', ->
    new_obj = {value: 'foo'}

    beforeEach ->
      sinon.stub(jQuery, 'ajax').yieldsTo('success', entry_2)
      
    afterEach ->
      jQuery.ajax.restore()

    it 'makes an ajax POST request to the CREATE url on the server', ->
      data_loader.create new_obj, ->
      jQuery.ajax.should.have.been.calledOnce
      args = jQuery.ajax.args[0][0]
      args.url.should.equal '/users'
      args.type.should.equal 'POST'

    it 'sends the object as payload', ->
      data_loader.create new_obj, ->
      args = jQuery.ajax.args[0][0]
      args.data.should.equal new_obj

    it "doesn't updates the server cache immediately because the object doesn't have an id", ->
      data_loader.create new_obj, ->
      expect(data_loader.server_data.get(1)).to.be.undefined

    it 'updates the server cache with the server data when the call returns', (done) ->
      data_loader.create {value: 'bar'}, (server_obj) ->
        data_loader.server_data.get(server_obj.id).should.equal entry_2
        done()

    it 'calls the given callback when done', (done) ->
      data_loader.create new_obj, ->
        done()


  describe 'delete', ->

    beforeEach ->
      sinon.stub(jQuery, 'ajax').yieldsTo('success')

    afterEach ->
      jQuery.ajax.restore()

    it 'makes an ajax DELETE request to the item url on the server', ->
      data_loader.delete entry_1
      jQuery.ajax.should.have.been.calledOnce
      args = jQuery.ajax.args[0][0]
      args.url.should.equal '/users/1'
      args.type.should.equal 'DELETE'

    it 'removes the object from the client and server cache', ->
      data_loader.server_data.add entry_1
      data_loader.client_data.add entry_1
      data_loader.delete entry_1
      data_loader.server_data.length().should.equal 0
      data_loader.client_data.length().should.equal 0

    it 'calls the given callback when done', (done) ->
      data_loader.delete entry_1, ->
        done()


  describe 'entry_url', ->

    it 'returns the url to access a single entry', ->
      data_loader.entry_url(entry_1).should.equal '/users/1'


  describe 'load_all', ->

    loading_done_callback = null
    beforeEach ->
      sinon.stub(jQuery, 'ajax').yieldsTo('success', [entry_1, entry_2])
      loading_done_callback = sinon.spy()
      data_loader.load_all loading_done_callback, {'q': 'foo'},

    afterEach ->
      jQuery.ajax.restore()
      
    it 'makes a request to the INDEX action of the server', ->
      jQuery.ajax.should.have.been.calledOnce
      jQuery.ajax.args[0][0].url.should.equal '/users'

    it 'provides the given data as parameters to the request', ->
      jQuery.ajax.args[0][0].data.should.eql {'q': 'foo'}

    it 'fills the server cache with the response data', ->
      data_loader.server_data.length().should.eql 2
      data_loader.server_data.get(1).should.eql entry_1
      data_loader.server_data.get(2).should.eql entry_2

    it 'calls the given callback method when the data is available', ->
      loading_done_callback.should.have.been.calledOnce


  describe 'load', ->

    describe 'entry exists in client data cache', ->
      it 'returns the entry from the @client_data cache if it exists there', (done) ->
        data_loader.client_data.add entry_1
        data_loader.load 1, (entry) ->
          entry.should.equal entry_1
          done()

    describe 'entry exists in server data cache', ->

      beforeEach ->
        data_loader.server_data.add entry_1

      it 'adds the entry to the client data cache', (done) ->
        data_loader.load 1, ->
          data_loader.client_data.length().should.equal 1
          data_loader.client_data.get(1).should.eql entry_1
          done()

      it 'returns the entry from the client data cache', (done) ->
        data_loader.load 1, (entry) ->
          client_cache_entry = data_loader.client_data.get 1
          entry.should.equal client_cache_entry
          done()

      it 'returns a different hash than the server data, so that the user can make changes to it', (done) ->
        data_loader.load 1, (entry) ->
          server_cache_entry = data_loader.server_data.get 1

          entry.should.not.equal server_cache_entry
          done()


    describe "entry doesn't exist on the client at all", ->
      
      beforeEach ->
        sinon.stub(jQuery, 'ajax').yieldsTo('success', entry_1)

      afterEach ->
        jQuery.ajax.restore()

      it "retrieves the entry from the server", (done) ->
        data_loader.load 1, ->
          jQuery.ajax.should.have.been.calledOnce
          done()


      it 'stores the entry in the server cache', (done) ->
        data_loader.load 1, ->
          data_loader.server_data.length().should.equal 1
          data_loader.server_data.get(1).should.equal entry_1
          done()

      it 'stores a replica of the entry in the client cache', (done) ->
        data_loader.load 1, ->
          data_loader.client_data.get(1).should.not.equal entry_1
          data_loader.client_data.get(1).should.eql entry_1
          done()

      it 'returns the client replica', (done) ->
        data_loader.load 1, (entry) ->
          data_loader.client_data.get(1).should.equal entry
          data_loader.server_data.get(1).should.not.equal entry
          done()


  describe 'save', ->

    describe 'for unsaved objects', ->
      it "calls the 'create' action", ->
        sinon.stub data_loader, 'create'
        data_loader.save {value: 'foo'}, ->
        data_loader.create.should.have.been.calledOnce

    describe 'for objects from the server', ->
      it "calls the 'update' action", ->
        sinon.stub data_loader, 'update'
        data_loader.save entry_1, ->
        data_loader.update.should.have.been.calledOnce


  describe 'update', ->

    beforeEach ->
      sinon.stub(jQuery, 'ajax').yieldsTo('success', entry_2)
      server_entry = {id: 1, title: 'server title', desc: 'server desc'}
      data_loader.server_data.add server_entry
      
    afterEach ->
      jQuery.ajax.restore()

    it 'makes an ajax PUT request to the UPDATE url on the server', ->
      data_loader.update entry_1, ->
      jQuery.ajax.should.have.been.calledOnce
      args = jQuery.ajax.args[0][0]
      args.url.should.equal '/users/1'
      args.type.should.equal 'PUT'

    it 'sends only updated colums of the object as payload', (done) ->
      data_loader.load 1, (client_entry) ->
        client_entry.title = 'client title'

        data_loader.update client_entry


        args = jQuery.ajax.args[0][0]
        args.data.should.eql {id: 1, title: 'client title'}
        done()

    it "doesn't perform the call if nothing is changed", (done) ->
      data_loader.load 1, (client_entry) ->
        data_loader.update client_entry
        jQuery.ajax.should.not.have.been.called
        done()

    it 'updates the server cache immediately with the given object', ->
      data_loader.update entry_1, ->
      data_loader.server_data.get(1).should.equal entry_1

    it 'updates the server cache with the server object when done', (done) ->
      data_loader.update entry_1, (server_obj) ->
        data_loader.server_data.get(2).should.equal entry_2
        done()

    it 'calls the given callback when done', (done) ->
      data_loader.update entry_1, ->
        done()

