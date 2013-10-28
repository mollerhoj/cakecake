class Entity
  name: null
  x: 0
  y: 0
  z: 0
  width: undefined
  height: undefined
  radius: undefined
  angle: 0

  start_x: 0
  start_y: 0
  start_z: 0
  start_width: undefined
  start_height: undefined
  start_radius: undefined
  start_angle: 0

  visible: true
  sprite: null
  world: null
  art: null

  constructor: ->
    @hit_hash = new Object()
    @unique = Math.generate_unique()

  draw: ->
    if @sprite
      @sprite.angle = @angle
      @sprite.width = @width
      @sprite.height = @height
      @sprite.x = @world.x + @x
      @sprite.y = @world.y + @y
      @sprite.draw()

  init: ->
    return null

  set_x: (x) ->
    @x = x
    @update_position()

  set_y: (y) ->
    @y = y
    @update_position()

  update_position: ->
    if @physics && @body
      @body.SetPosition(new b2Vec2(@x/AppData.pixel_per_meter,@y/AppData.pixel_per_meter))

  set_angle: (angle) ->
    @angle = angle
    if @physics && @body
      @body.SetAngle((-@angle/360)*Math.PI*2)

  set_width: (width) ->
    @width = width

  set_height: (height) ->
    @height = height

  step: ->
    if @physics && @body
      p = @body.GetPosition()
      @x=p.x*AppData.pixel_per_meter
      @y=p.y*AppData.pixel_per_meter
      @sprite.angle=-@body.GetAngle()/(Math.PI*2)*360
    return null

  move_towards: (x,y,speed) ->
    dir = @angle_to(x,y)
    set_x(@x+Math.cos(dir/180*Math.PI)*speed)
    set_y(@y+Math.sin(dir/180*Math.PI)*speed)
    
  angle_to: (x,y) ->
    return -Math.atan2(y - @y,x - @x)*180/Math.PI
    
  touch: (c) ->
    for key, val of @hit_hash
      if c == 'MOUSE' and key == 'MOUSE'
        return true
      else if val.name == c
        return val
    return null

  destroy: ->
    if @body
      @world.physics.world.DestroyBody(@body)
    @world.destroy this

  reset: ->
    @x = @start_x
    @y = @start_y
    @width = @start_width
    @height = @start_height
    @radius = @start_radius
    @angle = @start_angle

  #Helpers
  spawn: (cl) ->
    @world.spawn(cl,@x,@y)

