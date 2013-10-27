# Parent of all entities (user created game objects)
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

  hit_hash: {}

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
      @body.SetPosition(new b2Vec2(@x/Appdata.pixel_per_meter,@y/Appdata.pixel_per_meter))

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

  #TODO: Move physical body
  move_towards: (x,y,speed) ->
    dir = @angle_to(x,y)
    @x += Math.cos(dir/180*Math.PI)*speed
    @y -= Math.sin(dir/180*Math.PI)*speed
    
  angle_to: (x,y) ->
    return -Math.atan2(y - @y,x - @x)*180/Math.PI
    
  nearest: (c) ->
    shortest = 9999
    nearest = null
    for e in @world.all_entities()
      if e.name == c and e != this
        distance = @objects_distance(this,e) 
        if distance < shortest
          nearest = e
          shortest = distance
    return nearest

  touch: (c) ->
    for key, val of @hit_hash
      if val.name == c
        return val
    return null


  hit: (c) ->
    for e in @world.all_entities()
      if e.name == c
        if @objects_touch(this,e)
          return e
    return null

  hits: (c) ->
    res = []
    for e in @world.all_entities()
      if e.name == c
        if @objects_touch(this,e)
          res.push(e)
    return res

  spawn: (cl) ->
    @world.spawn(cl,@x,@y)

  objects_touch_circle: ->
    return @objects_distance(obj1,obj2) <= obj1.r+obj2.r

  objects_touch: (obj1,obj2) ->
    l1 = obj1.x-obj1.width/2
    r1 = obj1.x+obj1.width/2
    l2 = obj2.x-obj2.width/2
    r2 = obj2.x+obj2.width/2

    u1 = obj1.y-obj1.height/2
    d1 = obj1.y+obj1.height/2
    u2 = obj2.y-obj2.height/2
    d2 = obj2.y+obj2.height/2
    return r1 > l2 && l1 < r2 && d1 > u2 && u1 < d2

  objects_distance: (obj1,obj2) ->
    return @points_distance(obj1.x,obj1.y,obj2.x,obj2.y)

  points_distance: (x1,y1,x2,y2) ->
    return Math.sqrt(Math.pow(x1-x2,2)+Math.pow(y1-y2,2))

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

  # TODO. This should be moved to the collsion object.
  mouse_hits: ->
    return Keyboard.MOUSE_X > @x-@w/2 and
           Keyboard.MOUSE_X < @x+@w/2 and
           Keyboard.MOUSE_Y > @y-@h/2 and
           Keyboard.MOUSE_Y < @y+@h/2
