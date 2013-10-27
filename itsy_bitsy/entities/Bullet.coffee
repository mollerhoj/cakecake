class Bullet extends Entity

  angle: 0
  speed: 10

  step: ->
    @x += Math.cos(@angle/180*Math.PI)*@speed
    @y -= Math.sin(@angle/180*Math.PI)*@speed
