class Button extends Entity

  text: null
  menu: null
  id: 0

  draw: ->
    super()
    @text.x = @x
    @text.y = @y
    @text.draw()

  step: ->
    if @mouse_hits()
      if @menu
        if Keyboard.mouse_moves
          @menu.set_index(@id)
        if Keyboard.press('MOUSE_LEFT')
          @menu.press(@id)
