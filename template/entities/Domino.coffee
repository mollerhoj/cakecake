class Domino extends Entity
  physics:
    shape: 'rectangle'
    friction: 0.25
    density: 35
    restitution: 0.2
  body: null

  step: ->
    angle=@body.angle
    position = @body.GetPosition()
    @x=position.x*16
    @y=position.y*16
    @sprite.rotation=-angle/(Math.PI*2)*360


