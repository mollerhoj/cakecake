class Announcer extends Entity

  default_persistance: 60
  z: 2000

  time: 0
  txt: null
  callback: null

  init: ->
    @x = AppData.width/2
    @y = AppData.height/2
    @txt = new Text('',@x,@y)
    @txt.align = 'center'
    @txt.font = 'Norwester'
    @txt.font_size = 72

  say: (string,persistance=0,callback=null) ->
    @txt.string = string
    if persistance == 0
      persistance = @default_persistance
    @time = persistance
    @callback = callback

  step: ->
    if @time > 0
      @time-=1
      if @time == 0
        @callback()

      
  draw: ->
    if @time > 0
      @txt.draw()

