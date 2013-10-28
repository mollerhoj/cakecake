class Button extends Entity
  physics:
    shape: 'rectangle'
  body: null

  text: null
  menu: null
  id: 0

  init: ->
    @world.physics.build_edges()

  draw: ->
    super()
    @text.x = @x
    @text.y = @y
    @text.draw()

  step: ->
    if @touch('MOUSE')
      if @menu
        if Keyboard.press('MOUSE_LEFT')
          @menu.press(@id)
        if Keyboard.mouse_moves
          @menu.set_index(@id)
