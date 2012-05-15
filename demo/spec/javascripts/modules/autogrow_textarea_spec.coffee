#= require spec_helper
#= require modularity/modules/autogrow_textarea


describe 'AutogrowTextArea', ->

  autogrow = null
  beforeEach ->
    template 'autogrow_textarea'
    autogrow = new modularity.AutogrowTextArea '#konacha #autogrow_area'


  describe 'lines', ->

    it 'works for empty lines', ->
      modularity.AutogrowTextArea.lines(4, "\n\n\n").should == 3

    it 'works for short lines', ->
      modularity.AutogrowTextArea.lines(4, "1\n12\n123\n").should == 3

    it 'works for a long line', ->
      modularity.AutogrowTextArea.lines(4, "123456").should == 2

    it 'works for several long lines', ->
      modularity.AutogrowTextArea.lines(4, "123456\n123456").should == 4


  describe 'grow()', ->
    it 'sets the number of rows of the textarea according to the content area', ->
      autogrow.textarea.value = "111\n222\n333\n444\n555"
      autogrow.grow()
      autogrow.textarea.rows.should.equal(5)

    it 'sets the minimal number of rows if the content is less', ->
      $(autogrow.textarea).val('one')
      autogrow.grow()
      autogrow.textarea.rows.should.equal 3

    it 'can handle empty content', ->
      $(autogrow.textarea).val('')
      autogrow.grow()
      autogrow.textarea.rows.should.equal 3

