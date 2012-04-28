require('/spec/javascripts/external/jquery.min.js')
require('/spec/javascripts/external/coffee-script.js')

# Helper method to circumvent that Evergreen doesn't load CoffeeScript files.
window.loadCS = (url, callback) ->
  $.ajax
    url: url
    async: false
    success: (data) ->
      eval CoffeeScript.compile data
      callback() if callback


window.load_modularity = ->
  loadCS "/vendor/assets/javascripts/modularity.js.coffee?#{(new Date()).getTime()}"
