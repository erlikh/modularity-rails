#= require spec_helper
#= require modules/autogrow_textarea


describe 'AutogrowTextArea', ->

  describe 'lines', ->

    it 'works for empty lines', ->
      modularity.AutogrowTextArea.lines(4, "\n\n\n").should == 3

    it 'works for short lines', ->
      modularity.AutogrowTextArea.lines(4, "1\n12\n123\n").should == 3

    it 'works for a long line', ->
      modularity.AutogrowTextArea.lines(4, "123456").should == 2

    it 'works for several long lines', ->
      modularity.AutogrowTextArea.lines(4, "123456\n123456").should == 4

