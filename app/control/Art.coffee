# Art
# The object that draws on the canvas
# methods that ends with C draws relative to canvas. //Are they useful?
class Art
  world: null

  constructor: (world) ->
    @world = world

  get_alpha: ->
    return Game.context.globalAlpha

  alpha: (alpha) ->
    Game.context.globalAlpha = alpha

  color: (color) ->
    Game.context.fillStyle = color
    Game.context.strokeStyle = color

  fill_color: (color) ->
    Game.context.fillStyle = color

  stroke_color: (color) ->
    Game.context.strokeStyle = color

  lineC: (x1,y1,x2,y2) ->
    Game.context.beginPath()
    Game.context.moveTo(x1+0.5,y1+0.5)
    Game.context.lineTo(x2+0.5,y2+0.5)
    Game.context.stroke()

  line: (x,y,x2,y2) ->
    @lineC(x+@world.x,y+@world.y,x2+@world.x,y2+@world.y)

  rectangleC: (x,y,w,h,filled = false) ->
    if filled == true
      Game.context.fillRect(x,y,w,h)
    else
      Game.context.strokeRect(x,y,w,h)

  rectangle: (x,y,w,h,filled = false) ->
    Art.rectangleC(x+Art.offset_x,y+Art.offset_y,w,h,filled)

