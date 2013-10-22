class Menu_2D extends Entity

  index_x: -1
  index_y: 0
  button_n: 14
  texts: []
  cols: 4
  button_x_space: 100
  button_y_space: 50
  marker: null

  init: ->
    @x = 160
    @y = 300
    @marker = new Sprite('Marker')
    @texts[0] = new Text('Back')
    @texts[0].x = @x-@button_x_space
    @texts[0].y = @y

    for i in [1..@button_n]
      @texts[i] = new Text("Level #{i}")

    for i in [1..@button_n]
      t = @texts[i]
      if t
        t.align = 'center'
        t.font = 'Arial'
        t.y = @y + Math.floor((i-1) / @cols) * @button_y_space
        t.x = @x + ((i-1) % @cols) * @button_x_space

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

    for text in @texts
      text.draw()

    


