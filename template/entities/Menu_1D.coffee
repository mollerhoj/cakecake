class Menu_1D extends Entity

  index: 0
  button_n: 2
  texts: []
  button_space: 50
  marker: null
  spider: null

  init: ->
    @x = 50
    @y = 300
    @marker = new Sprite('Marker')
    @spider = new Sprite('Spider_Menu',450,350)
    @title = new Text('Itsy Bitsy',AppData.width/2,20)
    @credit = new Text('By Jens Dahl Mollerhoj',AppData.width/2,140)
    @credit.font_size = 20
    @credit.font = 'Norwester'
    @title.font_size = 120
    @title.font = 'Norwester'
    @texts[0] = new Text('Play')
    @texts[1] = new Text('Options')

    for i in [0...@button_n]
      t = @texts[i]
      if t
        t.align = 'left'
        t.font = 'Norwester'
        t.font_size = 30
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
    @marker.rotation+=1
    @marker.draw()

    @credit.draw()
    @spider.draw()
    @title.draw()

    for text in @texts
      text.draw()

    


