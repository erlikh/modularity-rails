#= require spec_helper

describe 'test environment setup', ->

  it 'loading libraries', ->
    load_modularity()
    loadCS "/vendor/assets/javascripts/mixins/clickable.coffee"
    loadCS "/vendor/assets/javascripts/modules/button.coffee"
    loadCS "/vendor/assets/javascripts/modules/close_button.coffee"


describe 'CloseButton', ->
  template 'button.html'

  describe 'without close_button div provided', ->
    it 'finds the close button div automatically', ->
      new CloseButton('#test #closable1')
      $('#test #closable1 .CloseButton').click()

      expect($('#test #closable1').length).toEqual(0)

  describe 'with close_button div provided', ->
    it 'only fires when clicking on the provided close section', ->
      new CloseButton('#test #closable2', $('#test .CustomCloseButton'))
      $('#test #closable2 .CustomCloseButton').click()

      expect($('#test #closable2').length).toEqual(0)
