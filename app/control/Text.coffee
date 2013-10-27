class Text
  name: null
  x: 0
  y: 0
  z: 0
  visible: true
  alpha: 1
  angle: 0
  index: 1

  align: 'center'

  font: 'Dosis'
  font_size: 16
  font_style: "" # "", bold, italic,
  color: 'black'
  string: ''
  stroke: true
  stroke_color: 'white'
  stroke_size: 2

  constructor: (string='',x=0,y=0) ->
    @string = string
    @x = x
    @y = y

  draw: (string='',x=0,y=0) ->
    @_update()
    if @angle != 0
      Game.context.save()
      Game.context.translate(@x+get_width()/2,@y+@get_height()/2)
      Game.context.rotate(Math.PI/180*@angle)
      Game.context.fillText(@string,-@get_width()/2,-@get_height()/2)
      Game.context.restore()
    else
      Game.context.fillStyle = @color
      Game.context.strokeStyle = @stroke_color
      Game.context.lineWidth = @stroke_size*2
      Game.context.strokeText(@string, @x, @y)
      Game.context.fillText(@string, @x, @y)

  get_width: ->
    @_update()
    return Game.context.measureText(@string).width

  get_height: ->
    return @font_size

  _update: ->
    Game.context.font = @font_style + " " + @font_size + "px '" + @font + "'"
    Game.context.textAlign=@align

