require('/public/javascripts/jquery.min.js')
require('/public/javascripts/coffee-script.js')

load = (url, callback) ->
  $.get url, null, (data) ->
    eval CoffeeScript.compile data
    callback()


describe 'modularity', ->

    describe 'constructor', ->

      it 'shows an error if no container is given', ->
        load '/vendor/assets/javascripts/modularity.js.coffee', (data) ->
          new Module()
