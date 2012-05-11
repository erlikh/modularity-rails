#= require application
#= require sinon
#= require sinon-chai
#= require_tree ./templates

window.chai.use window.sinonChai

# Renders the template with the given path in the #konacha div.
window.template = (path) ->
  $('#konacha').html JST["templates/#{path}"]()

