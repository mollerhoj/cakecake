class Menu_1D extends Entity

  index: 0
  button_n: 2
  texts: []
  button_space: 50
  marker: null

  init: ->
    @x = 100
    @y = 300
    @marker = new Sprite('Marker')
    @texts[0] = new Text('Play')
    @texts[1] = new Text('Options')

    for i in [0...@button_n]
      t = @texts[i]
      if t
        t.align = 'left'
        t.font = 'Arial'
        t.y = @y + i * @button_space
        t.x = @x

  step: ->
    if Keyboard.press('DOWN')
      @index += 1
    if Keyboard.press('UP')
      @index -= 1
    if Keyboard.press('SPACE')
      if @index == 0
        @destroy()
        @spawn('Menu_2D')

    if @index < 0
      @index = 0
    if @index > @button_n-1
      @index = @button_n-1

  draw: ->
    @marker.y = @y + @index * @button_space
    @marker.x = @x + @marker.w/4
    @marker.draw()

    for text in @texts
      text.draw()

    


