class Snake extends Entity
  dir: 0
  time: 0
  z: 10
  hits_self: false

  init: ->
    r: 10000

  step: ->

    if !@hits_self
      if Keyboard.hold('RIGHT') 
        @dir = 0
      if Keyboard.hold('UP') 
        @dir = 90
      if Keyboard.hold('LEFT') 
        @dir = 180
      if Keyboard.hold('DOWN') 
        @dir = 270
      
    if @dir==0
      @x += 4
    if @dir==90
      @y -= 4
    if @dir==180
      @x -= 4
    if @dir==270
      @y += 4

    @sprite.rotation = @dir

    @time+=1
    rx = Math.random()*2
    ry = Math.random()*2
    @world.spawn('SnakeBody',@x-1+rx,@y-1+ry)

    if @x < 0
      @x = AppData.width 
    if @y < 0
      @y = AppData.height
    if @x > AppData.width
      @x = 0
    if @y > AppData.height
      @y = 0

    @hits_self = false

    if @hits('SnakeBody').some((x)->x.solid)
      @hits_self = true 


  outside: ->
    return @x < 0 || @x > AppData.width || @y < 0 || @y > AppData.height

  draw: ->
    if !@hits_self
      @sprite.x = @x
      @sprite.y = @y
      @sprite.draw()
