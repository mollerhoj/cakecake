class Menu_2D extends Entity

  index_x: -1
  index_y: 0
  button_n: 14
  buttons: []
  cols: 4
  button_x_space: 100
  button_y_space: 50
  marker: null
  headline: "Select Level"
  heading: null
  heading_x: 320
  heading_y: 220

  init: ->
    @x = 160
    @y = 300
    @marker = new Sprite('Marker')

    @heading = new Text(@headline,@heading_x,@heading_y)
    @heading.align = 'center'
    @heading.font = 'Norwester'
    @heading.font_size = 60

    b = @world.spawn('Button')
    b.x = @x-@button_x_space
    b.y = @y
    b.text = new Text('Back')

    @buttons[0] = b

    for i in [1..@button_n]
      b = @world.spawn('Button')
      b.text = new Text("Level #{i}")
      @buttons[i] = b

    for i in [1..@button_n]
      b = @buttons[i]
      if b
        b.text.align = 'center'
        b.text.font = 'Norwester'
        b.y = @y + Math.floor((i-1) / @cols) * @button_y_space
        b.x = @x + ((i-1) % @cols) * @button_x_space

  space: ->
    if @index_x == -1
      @destroy()
      @spawn('Menu_1D')
    else
      @goto_level(1+@index_y*@cols+@index_x)

  goto_level: (lvl) ->
    @world.destroy_all()
    @world.load_level("Level",lvl)

  step: ->
    if Keyboard.press('SPACE')
      @space()

    if Keyboard.press('DOWN')
      @index_y += 1
    if Keyboard.press('UP')
      @index_y -= 1
    if Keyboard.press('RIGHT')
      @index_x += 1
    if Keyboard.press('LEFT')
      @index_x -= 1

    if @index_x < 0
      @index_y = 0

    if @index_x < -1
      @index_x = -1

    if @index_y < 0
      @index_y = 0

    if @index_y > Math.floor(@button_n/@cols)
      @index_y = Math.floor(@button_n/@cols)

    if @index_x > @cols-1
      @index_x = @cols-1

  draw: ->
    @marker.y = @y + @index_y * @button_y_space
    @marker.x = @x + @index_x * @button_x_space + @marker.w/4
    @marker.draw()
    @heading.string = @headline
    @heading.draw()

