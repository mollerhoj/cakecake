class GameController extends Entity
  @score: 0
  text: null
  world: null
  date: 0
  
  init: ->
    @text = new Text('10',10,10)
    @text.align = 'left'

  draw: ->
    tmp_date = new Date
    sec =  tmp_date-@date
    @date = tmp_date
    @text.string = sec
    @text.draw()

