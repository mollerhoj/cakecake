class GameController extends Entity
  @score: 0
  text: null
  world: null
  
  init: ->
    @text = new Text('10',10,10)

  draw: ->
    @text.string = GameController.score
    @text.draw()

