class Pendulum extends Entity
  physics:
    shape: 'rectangle'
    friction: 0.25
  body: null

  speed: 2
  jump_power: 800
  crawl_speed: 0.1
  joint_last_angle: 90

  rope: []
  rope_length: 0

  joint: null
  bullet: null

  dis_joint: (x,y) ->
    jointDef = new b2DistanceJointDef()
    jointDef.Initialize(@world.physics.solid, @body, new b2Vec2(x/16,y/16), @body.GetWorldCenter())
    jointDef.collideConnected = true
    @joint = @world.physics.world.CreateJoint(jointDef)

  dis_joint_off: ->
    vec = @joint.GetAnchorB().Copy()
    vec.Subtract(@joint.GetAnchorA())
    @joint_last_angle = vec.angle()/(Math.PI*2)*360
    @world.physics.world.DestroyJoint(@joint)
    @joint = null

  ray_shoot: (x,y) ->
    input = new b2RayCastInput()
    output = new b2RayCastOutput()
    input.p1 = new b2Vec2(@body.GetPosition().x,@body.GetPosition().y)
    input.p2 = new b2Vec2(x/16,y/16)

    b = @world.physics.world.GetBodyList()
    while b
      f = b.GetFixtureList()
      while f
        if f.RayCast(output,input,b.GetTransform())
          vec = input.p2.Copy()
          vec.Subtract(input.p1)
          x1 = @x
          y1 = @y
          x2 = @x+vec.x*16*output.fraction
          y2 = @y+vec.y*16*output.fraction
          return new b2Vec2(x2,y2)
        f = f.GetNext()
      b = b.GetNext()


  step: ->
    if Keyboard.press('J')
      if not @bullet
        if @joint
          @dis_joint_off()
          @rope = []
          @rope_length = 0
        else
          @bullet = @spawn('Bullet',@x,@y)
          dir = (@joint_last_angle + 360) % 360
          if dir < 45
            dir = 45
          else if dir > 270
            dir = 45
          else if dir > 90+45
            dir = 90+45
          @bullet.direction = dir

    if @joint
      if Keyboard.hold('LEFT')
        @body.ApplyImpulse(new b2Vec2(-@speed,0),@body.GetWorldCenter())
      if Keyboard.hold('RIGHT')
        @body.ApplyImpulse(new b2Vec2(@speed,0),@body.GetWorldCenter())
      if Keyboard.hold('DOWN')
        @joint.SetLength(@joint.GetLength()+@crawl_speed)
      if Keyboard.hold('UP')
        @joint.SetLength(@joint.GetLength()-@crawl_speed)

    angle=@body.GetAngle()
    position = @body.GetPosition()
    @x=position.x*16
    @y=position.y*16
    @sprite.rotation=-angle/(Math.PI*2)*360

  draw: ->
    super()
    if @bullet
      @rope[0] = new b2Vec2(@bullet.x,@bullet.y)
      @rope_length = 1
      if hit = @ray_shoot(@bullet.x,@bullet.y)
        @bullet.destroy()
        @bullet = null
        @dis_joint(hit.x,hit.y)
        @rope[0] = new b2Vec2(hit.x,hit.y)

    if @joint
      # Remove knot
      if @rope_length > 1
        xx = @rope[@rope_length-2].x
        yy = @rope[@rope_length-2].y
        vec = new b2Vec2(xx,yy)
        vec.Subtract(new b2Vec2(@x,@y))
        vec.Normalize()
        xx = @rope[@rope_length-2].x - vec.x*4
        yy = @rope[@rope_length-2].y - vec.y*4
        Art.stroke_color('red')
        Art.line(@x,@y,xx,yy)
        Art.stroke_color('blue')
        if not hit = @ray_shoot(xx,yy)
          @rope_length -= 1
          @world.physics.world.DestroyJoint(@joint)
          @joint = null
          @dis_joint(@rope[@rope_length-1].x,@rope[@rope_length-1].y)

      # New knot
      vec = @joint.GetAnchorB().Copy()
      vec.Subtract(@joint.GetAnchorA())
      vec.Normalize()
      xx = @rope[@rope_length-1].x + vec.x
      yy = @rope[@rope_length-1].y + vec.y
      if hit = @ray_shoot(xx,yy)
        @rope[@rope_length] = new b2Vec2(hit.x,hit.y)
        @rope_length += 1

        @world.physics.world.DestroyJoint(@joint)
        @joint = null
        @dis_joint(hit.x,hit.y)


    px = null
    py = null
    @rope[@rope_length] = new b2Vec2(@x,@y)

    n = 0
    for i in [0..@rope_length]
      knot = @rope[i]
      if knot
        if n > 0
          Art.line(px,py,knot.x,knot.y)
        px = knot.x
        py = knot.y
        n++

  destroy: ->
    @world.physics.world.DestroyBody(@body)
    super()
