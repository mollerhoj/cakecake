class Fly extends Entity
  physics:
    shape: 'circle'

  radius: 20
  ani: 0
  flare: null

  init: ->
    @flare = new Sprite('Flare',@x,@y)

  step: ->
    @ani+=1

  draw: ->
    @x = @start_x+Math.cos(@ani/180*Math.PI)*5
    @y = @start_y+Math.sin(@ani/180*Math.PI)*5
    super()
    @flare.x = @x
    @flare.y = @y
    @flare.draw()
