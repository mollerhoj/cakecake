class Sprite
  x: 0
  y: 0
  visible: true
  alpha: 1
  rotation: 0
  index: 1
  z: 0
  name: null
  w: undefined
  h: undefined

  constructor: (name='PlaceHolder',x=0,y=0) ->
    @name = name
    @x = x
    @y = y
    @w = Game.images[name].width
    @h = Game.images[name].height

  draw: ->
    image = @_get_image()
    x = @x - @w/2
    y = @y - @h/2
    if @rotation == 0 and @w == image.width and @h == image.height
      #Math.round for performance
      Game.context.drawImage(image,0,0,Math.round(@w),Math.round(@h),Math.round(x),Math.round(y),Math.round(@w),Math.round(@h))
    else
      w = image.width
      h = image.height
      Game.context.save()
      Game.context.translate(x+@w/2,y+@h/2)
      Game.context.rotate(-Math.PI/180*(@rotation%360))
      Game.context.scale(@w/w,@h/h)
      Game.context.translate(-@w/2,-@h/2)
      Game.context.drawImage(image,0,0,@w,@h)
      #Game.context.drawImage(image,0,0,image.width,image.height,0,0,image.width,image.height)
      #Game.context.drawImage(image,0,0,@w,@h,-(w+(@w/w))/2,-(h+(@h/h))/2,@w,@h)
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
