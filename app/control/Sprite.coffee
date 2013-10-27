class Sprite
  name: null
  x: 0
  y: 0
  z: 0
  visible: true
  alpha: 1
  angle: 0
  index: 1
  width: undefined
  height: undefined

  constructor: (name='PlaceHolder',x=0,y=0) ->
    @name = name
    @x = x
    @y = y
    @width = Game.images[name].width
    @height = Game.images[name].height

  draw: ->
    image = @_get_image()
    x = @x - @width/2
    y = @y - @height/2
    if @angle == 0 and @w == image.width and @h == image.height
      #Math.round for performance
      Game.context.drawImage(image,0,0,Math.round(@width),
                                        Math.round(@height),
                                        Math.round(x),
                                        Math.round(y),
                                        Math.round(@width),
                                        Math.round(@height) )
    else
      width = image.width
      height = image.height
      Game.context.save()
      Game.context.translate(x+@width/2,y+@height/2)
      Game.context.rotate(-Math.PI/180*(@angle%360))
      Game.context.scale(@width/width,@height/height)
      Game.context.translate(-@width/2,-@height/2)
      Game.context.drawImage(image,0,0,@width,@height)
      Game.context.restore()

  _get_image: ->
    if @index != 1
      result = Game.images[@name+@index]
    else
      result = Game.images[@name]

    if not result
      console.log "#{name} not found."
      result = Game.images['PlaceHolder']
    return result
