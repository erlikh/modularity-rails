require('/public/javascripts/jquery.min.js')
require('/public/javascripts/coffee-script.js')

# Helper method to circumvent that Evergreen doesn't load CoffeeScript files.
loadCS = (url, callback) ->
  $.ajax
    url: url
    async: false
    success: (data) ->
      eval CoffeeScript.compile data
      callback() if callback

# Helper method to load the modularity library before the tests.
describe 'modularity loader', ->
  it 'loading Modularity library ...', ->
    loadCS '/vendor/assets/javascripts/modularity.js.coffee'


describe 'modularity', ->

  template 'test.html'

  describe 'constructor', ->

    beforeEach ->
      spyOn window, 'alert'

    it 'shows an error if no container is given', ->
      new Module()
      expect(alert).toHaveBeenCalled()

    it 'shows an error if the container is not a jQuery object', ->
      new Module({})
      expect(alert).toHaveBeenCalled()

    it 'shows an error if the container is an empty jQuery object', ->
      new Module($('.zonk'))
      expect(alert).toHaveBeenCalled()

    it 'shows an error if the container has more than one elements', ->
      new Module($('.double'))
      expect(alert).toHaveBeenCalled()

    it "allows to provide 'testing' in tests", ->
      new Module('testing')
      expect(alert).not.toHaveBeenCalled()


  describe 'assert', ->

    # Variables that should be accessible in both the beforeEach block and the tests.
    module = null

    beforeEach ->
      spyOn window, 'alert'
      module = new Module('testing')

    it 'shows an alert with the given message if the given condition is false', ->
      module.assert false, 'Message'
      expect(alert).toHaveBeenCalledWith("Message")

    it 'fails when the condition is null', ->
      module.assert null, 'Message'
      expect(alert).toHaveBeenCalledWith("Message")

    it 'fails when the condition is undefined', ->
      module.assert undefined, 'Message'
      expect(alert).toHaveBeenCalledWith("Message")

    it 'fails when the condition is an empty array', ->
      module.assert [], 'Message'
      expect(alert).toHaveBeenCalledWith("Message")

    it 'fails when the condition is an empty string', ->
      module.assert '', 'Message'
      expect(alert).toHaveBeenCalledWith("Message")

    it 'passes when the condition is a string', ->
      module.assert '123', 'Message'
      expect(alert).not.toHaveBeenCalled()


  describe 'jQuery Integration', ->

    beforeEach ->
      spyOn window, 'alert'

    it 'works', ->
      $('#module_container').module(Module)
      expect(alert).not.toHaveBeenCalled()

    it 'returns the created instance', ->
      result = $('#module_container').module(Module)
      expect(result).toBeDefined()
      expect(typeof result).toEqual('object')

    it 'returns an error if the given parameter is not a class', ->
      $('#test').module()
      expect(alert).toHaveBeenCalled()

    it 'returns an error if the jQuery object is empty.', ->
      $('#zonk').module(Module)
      expect(alert).toHaveBeenCalled()
