class Fly extends Entity
  physics:
    shape: 'circle'

  flare: null

  init: ->
    @flare = new Sprite('Flare',@x,@y)


  draw: ->
    super()
    @flare.draw()
