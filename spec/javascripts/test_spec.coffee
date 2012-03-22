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


describe 'modularity', ->

    describe 'constructor', ->

      it 'shows an error if no container is given', ->
        loadCS '/vendor/assets/javascripts/modularity.js.coffee', (data) ->
          spyOn window, 'alert'
          new Module()
          expect(alert).toHaveBeenCalledWith('Error in Module constructor: No container given.')
