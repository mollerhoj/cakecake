class Button extends Entity

  @text: null
  
  draw: ->
    super()
    @text.x = @x
    @text.y = @y
    @text.draw()
