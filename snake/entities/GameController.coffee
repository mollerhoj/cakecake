class GameController extends Entity
  @score: 0
  text: null
  world: null
  
  init: ->
    @text = new Text('10',10,10)
    @world.spawn('Snake',100,100)
    @world.spawn('Apple',100,100)

  draw: ->
    @x = Keyboard.MOUSE_X
    @y = Keyboard.MOUSE_Y
    @text.string = GameController.score
    @text.string = @direction_to(320/2,240/2)
    @text.draw()


