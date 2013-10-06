class Apple extends Entity

  step: ->
    ni = @nearest('SnakeBody')
    if ni
      @move_towards(ni.x,ni.y,0.5)
    if (@hit('SnakeBody'))
      GameController.lives -= 1
      @die()

    if GameController.lives < 0
      @world.reset()

    if @hit('Snake')
      @die()

  die: ->
      side1 = Math.floor(Math.random()*2)
      side2 = Math.floor(Math.random()*2)
      if side1 == 0
        @x = Math.random()*AppData.width
        @y = side2
      else
        @x = side2
        @y = Math.random()*AppData.height
      GameController.score += 1

