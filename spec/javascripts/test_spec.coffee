require('/public/javascripts/jquery.min.js')
require('/public/javascripts/coffee-script.js')

# Helper method to circumvent that Evergreen doesn't load CoffeeScript files.
loadCS = (url, callback) ->
  $.ajax
    url: url
    async: false
    success: (data) ->
      eval CoffeeScript.compile data
      callback()

# Helper method that loads the Modularity file in tests.
loadModularity = (callback) ->
  loadCS '/vendor/assets/javascripts/modularity.js.coffee', callback


describe 'modularity', ->

  describe 'constructor', ->

    beforeEach ->
      spyOn window, 'alert'

    it 'shows an error if no container is given', ->
      loadModularity ->
        new Module()
        expect(alert).toHaveBeenCalledWith('Error in Module constructor: No container given.')

    it 'shows an error if the container is not a jQuery object', ->
      loadModularity ->
        new Module({})
        expect(alert).toHaveBeenCalledWith('Error in Module constructor: The given container must be a jQuery object.')

    it 'shows an error if the container is an empty jQuery object', ->
      loadModularity ->
        new Module($('.zonk'))
        expect(alert).toHaveBeenCalledWith("Error in Module constructor: The given container ('.zonk') is empty.")

    it "allows to provide 'testing' in tests", ->
      loadModularity ->
        new Module('testing')
        expect(alert).not.toHaveBeenCalled()

  describe 'assert', ->

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

