class GameController extends Entity
  @score: 0
  @lives: 10
  text: null
  world: null
  life_sprites: []
  
  init: ->
    for i in [0..10] by 1
      @life_sprites[i] = new Sprite('Heart')
      @life_sprites[i].y = 240-16
    @text = new Text('10',10,10)
    @world.spawn('Snake',100,100)
    @world.spawn('Apple',100,100)

  draw: ->
    @x = Keyboard.MOUSE_X
    @y = Keyboard.MOUSE_Y
    @text.string = GameController.score
    @text.draw()
    for i in [0..GameController.lives] by 1
      @life_sprites[i].x = 16+16*i
      @life_sprites[i].draw()


