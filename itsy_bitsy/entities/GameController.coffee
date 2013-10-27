class GameController extends Entity
  @score: 0
  text: null
  world: null
  date: 0
  announcer: null
  won: false
  
  init: ->
    @announcer = @world.spawn('Announcer')
    @announcer.say('Catch the fly!',100)
    @text = new Text('10',10,10)
    @text.align = 'left'

  step: ->
    if Keyboard.press('ESCAPE')
      @world.change_level('Menu')

    if not @hero
      @hero = @world.entities_of_class('Spider')[0]

    if not @tutorial
      @tutorial = @world.entities_of_class('Tutorial')[0]
    
    if @hero
      if @hero.y > AppData.height
        @lose()
      if @hero.touch('Fly')
        if @tutorial
          @tutorial.fly_taken(@win)
        else
          @win()

  lose: =>
    if not @won
      @world.reset()
      

  win: =>
    if not @won
      @won = true
      Storage.save('level_n_reached',@world.current_level_n+1)
      @announcer.say('Well Done!',140,@world.next_level)

  draw: ->
    tmp_date = new Date
    sec =  tmp_date-@date
    @date = tmp_date
    @text.string = sec
    @text.draw()

