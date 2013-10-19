class Hero extends Entity

  direction: 0
  move: 'WALKING' #STANDING JUMPING ETC
  animation: 0

  init: ->

  step: ->
    face_x = 0
    face_y = 0
    if Keyboard.hold('RIGHT')
      face_x +=1
    if Keyboard.hold('LEFT')
      face_x -=1
    if Keyboard.hold('UP')
      face_y -=1
    if Keyboard.hold('DOWN')
      face_y +=1

    @move = 'WALKING'

    if face_x == -1
      if face_y == -1
        @direction = 90+45
      if face_y == 0
        @direction = 180
      if face_y == 1
        @direction = 180+45
    
    if face_x == 0
      if face_y == -1
        @direction = 90
      if face_y == 0
        @move = 'STANDING'
      if face_y == 1
        @direction = 270

    if face_x == 1
      if face_y == -1
        @direction = 45
      if face_y == 0
        @direction = 0
      if face_y == 1
        @direction = 270+45

    @sprite.scale_x = 1

    if @direction == 0
      @sprite.index = 5

    if @direction == 45
      @sprite.index = 7

    if @direction == 90
      @sprite.index = 9

    if @direction == 90+45
      @sprite.index = 7
      @sprite.scale_x = -1

    if @direction == 180
      @sprite.index = 5
      @sprite.scale_x = -1

    if @direction == 180+45
      @sprite.index = 3
      @sprite.scale_x = -1

    if @direction == 270
      @sprite.index = 1

    if @direction == 270+45
      @sprite.index = 3

    if @animation > 20
      @animation = 0

    if @animation > 10
      @sprite.index +=1

    if @move == 'WALKING'
      @animation += 1
      @x += Math.cos(@direction/180*Math.PI)
      @y -= Math.sin(@direction/180*Math.PI)
      if @hit('Block')
        console.log 'block'
        @x -= Math.cos(@direction/180*Math.PI)
        @y += Math.sin(@direction/180*Math.PI)

    if Keyboard.press('X')
      fireball_sound = new Audio('sounds/shotgun.wav')
      fireball_sound.go()
      f = @world.spawn('Fireball',@x,@y)
      f.direction = @direction

    @world.x = @x-AppData.width/2
    @world.y = @y-AppData.height/2


