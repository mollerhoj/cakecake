class Bullet extends Entity

  direction: 0
  speed: 10

  step: ->
    @x += Math.cos(@direction/180*Math.PI)*@speed
    @y -= Math.sin(@direction/180*Math.PI)*@speed
