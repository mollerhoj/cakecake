# Grid
class Grid
  sx: 0
  sy: 0
  visible: false
  x: 0
  y: 0
  width: 16
  height: 16
  world_x: 0
  world_y: 0
  art: null

  constructor: ->
    @visible = AppData.grid_on
    @width = AppData.pixel_per_meter
    @height = AppData.pixel_per_meter

  draw: ->
    if @visible and @height > 1 and @width > 1
      @art.stroke_color('Gray')
      @art.alpha 0.5
      line_x_n = AppData.width/@width
      line_y_n = AppData.height/@height
      for i in [0...line_x_n]
        x = @x+i*@width
        @art.lineC(x,@y,x,@y+line_y_n*@height)
      for i in [0...line_y_n]
        y = @y+i*@height
        @art.lineC(@x,y,@x+line_x_n*@width,y)
      @art.alpha 1
