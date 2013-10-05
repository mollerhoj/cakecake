class Apple extends Entity

  step: ->
    ni = @nearest('SnakeBody')
    if ni
      @move_towards(ni.x,ni.y,0.5)
    while (@hit('SnakeBody'))
      @move_towards(ni.x,ni.y,-0.5)
      
