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

    it 'shows an error if no container is given', ->
      loadModularity ->
        spyOn window, 'alert'
        new Module()
        expect(alert).toHaveBeenCalledWith('Error in Module constructor: No container given.')

    it 'shows an error if the container is not a jQuery object', ->
      loadModularity ->
        spyOn window, 'alert'
        new Module({})
        expect(alert).toHaveBeenCalledWith('Error in Module constructor: The given container must be a jQuery object.')

    it 'shows an error if the container is an empty jQuery object', ->
      loadModularity ->
        spyOn window, 'alert'
        new Module($('.zonk'))
        expect(alert).toHaveBeenCalledWith("Error in Module constructor: The given container ('.zonk') is empty.")

    it "allows to provide 'testing' in tests", ->
      loadModularity ->
        spyOn window, 'alert'
        new Module('testing')
        expect(alert).not.toHaveBeenCalled()

