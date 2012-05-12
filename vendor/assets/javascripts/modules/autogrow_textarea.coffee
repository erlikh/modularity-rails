# Autogrowing textarea.
class window.modularity.AutogrowTextArea extends modularity.Module

  constructor: (container) ->
    super
    @textarea = @container[0]
    @textarea.style.height = "auto"
    @textarea.style.overflow = "hidden"
    @container.keyup @grow
    @container.focus @grow
    @container.blur @grow

    # How many characters per line.
    @characters_per_line = this.textarea.cols

    # The initial (minimal) number of rows.
    @min_rows = this.textarea.rows

    @grow()


  # Sets the height of the textarea according to the content.
  grow: =>
    @textarea.rows = Math.max modularity.AutogrowTextArea.lines(@characters_per_line, @textarea.value), @min_rows

  # Returns the number of lines 
  @lines: (width, text) ->
    lines_count = 0
    lines = text.split(/\n/)
    lines_count += Math.floor((line.length / width) + 1) for line in lines
    lines_count
