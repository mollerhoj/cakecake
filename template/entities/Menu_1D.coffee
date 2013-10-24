class Menu_1D extends Entity

  index: 0
  button_n: 2
  buttons: []
  button_space: 50
  marker: null
  spider: null

  init: ->
    @y = 300
    @marker = new Sprite('Marker')
    @spider = new Sprite('Spider_Menu',450,350)
    @credit = new Text('By Jens Dahl Mollerhoj',AppData.width/2,140)
    @credit.font_size = 20
    @credit.font = 'Norwester'
    @title = new Text('Itsy Bitsy',AppData.width/2,70)
    @title.font_size = 120
    @title.font = 'Norwester'

    for i in [0...@button_n]
      b = @world.spawn('Button')
      b.id = i
      b.x = 60
      b.w = 100
      b.h = 20
      b.y = @y + i * @button_space
      b.sprite = null
      b.text = new Text('Play')
      b.text.font = 'Norwester'
      b.text.font_size = 30
      b.text.align = 'left'
      b.menu = this
      @buttons[i] = b

    @buttons[0].text.string = 'Play'
    @buttons[1].text.string = 'Options'

  set_index: (i) ->
    @index = i

  press: (i) ->
    if @index == 0
      @destroy()
      if Storage.load('level_n_reached') && Storage.load('level_n_reached') > 1
        @spawn('Menu_2D')
      else
        @world.destroy_all()
        @world.load_level("Level")

  step: ->
    if Keyboard.press('DOWN')
      @index += 1
    if Keyboard.press('UP')
      @index -= 1
    if Keyboard.press('SPACE')
      @press(@index)

    if @index < 0
      @index = 0
    if @index > @button_n-1
      @index = @button_n-1

  draw: ->
    @marker.y = @y + @index * @button_space
    if @index == 0
      @marker.w = 90
      @marker.x = 90
    if @index == 1
      @marker.x = 110
      @marker.w = 110
    @marker.draw()

    @credit.draw()
    @spider.draw()
    @title.draw()

    for button in @buttons
      button.draw()

  destroy: ->
    super()
    for button in @buttons
      button.destroy()


