class Pad extends Entity
  speed: 4
  
  step: ->
    if Keyboard.hold('LEFT')
      if @x > @w/2
        @x -= @speed
    if Keyboard.hold('RIGHT')
      if @x < 320-@w/2
        @x += @speed
