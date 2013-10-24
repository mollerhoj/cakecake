class Menu_2D extends Entity

  index_x: -1
  index_y: 0
  button_n: 15
  buttons: []
  z: 2001
  cols: 5
  button_x_space: 80
  button_y_space: 70
  marker: null
  headline: "Select Level"
  heading: null
  heading_x: 320
  heading_y: 220

  init: ->
    @title = new Text('Itsy Bitsy',AppData.width/2,70)
    @title.font_size = 120
    @title.font = 'Norwester'
    @credit = new Text('By Jens Dahl Mollerhoj',AppData.width/2,140)
    @credit.font_size = 20
    @credit.font = 'Norwester'

    @x = 160
    @y = 300
    @marker = new Sprite('Marker_square')

    @heading = new Text(@headline,@heading_x,@heading_y)
    @heading.align = 'center'
    @heading.font = 'Norwester'
    @heading.font_size = 80

    b = @world.spawn('Button')
    b.x = @x-@button_x_space
    b.y = @y
    b.sprite = null
    b.text = new Text('Back')
    b.text.font = 'Norwester'
    b.menu = this

    @buttons[0] = b

    for i in [1..@button_n]
      b = @world.spawn('Button')
      b.text = new Text("#{i}")
      @buttons[i] = b

    for i in [1..@button_n]
      b = @buttons[i]
      if b
        b.text.align = 'center'
        b.text.font = 'Norwester'
        b.text.font_size = 23
        b.y = @y + Math.floor((i-1) / @cols) * @button_y_space
        b.x = @x + ((i-1) % @cols) * @button_x_space
        b.id = i
        b.menu = this

  set_index: (i) =>
    @index_x = (i-1)%@cols
    @index_y = Math.floor((i-1)/@cols)

  get_index: ->
    return 1+@index_y*@cols+@index_x

  press: (index) ->
    if @index_x == -1
      @destroy()
      @spawn('Menu_1D')
    else
      @goto_level(index)

  destroy: ->
    super()
    for b in @buttons
      b.destroy()

  goto_level: (lvl) ->
    @world.destroy_all()
    @world.load_level("Level",lvl)

  step: ->
    if Keyboard.press('SPACE')
      @press(@get_index())

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

    if @index_y > Math.floor(@button_n/@cols)-1
      @index_y = Math.floor(@button_n/@cols)-1

    if @index_x > @cols-1
      @index_x = @cols-1

  draw: ->
    @marker.y = @y + @index_y * @button_y_space
    @marker.x = @x + @index_x * @button_x_space
    @marker.draw()
    @title.draw()
    @credit.draw()
    @heading.string = @headline
    @heading.draw()

