class GameController extends Entity
  @score: 0
  text: null
  world: null
  date: 0
  announcer: null
  won: false
  
  init: ->
    @announcer = @world.spawn('Announcer')
    @text = new Text('10',10,10)
    @text.align = 'left'
    

  step: ->
    if Keyboard.press('ESCAPE')
      @world.change_level('Menu')

    if not @hero
      @hero = @world.entities_of_class('Spider')[0]
    
    if @hero
      if @hero.touch('Fly')
        @win()



  win: =>
    if not @won
      @won = true
      console.log 'won'
      @announcer.say('Well Done!',140,@world.next_level)

  draw: ->
    tmp_date = new Date
    sec =  tmp_date-@date
    @date = tmp_date
    @text.string = sec
    @text.draw()

