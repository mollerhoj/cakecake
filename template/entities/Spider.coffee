class Spider extends Entity
  # TODO:
  # /Friction in swing
  # /Force left/right
  # crawl control
  # /Point move to vertex/radius?
  physics:
    shape: 'circle'
    friction: 0.25
    density: 15
    restitution: 0.95
    type: 'dynamic'
  body: null

  r: 5
  speed: 2
  jump_power: 800
  crawl_speed: 0.1
  aim: 30
  aim2: 90

  rope: []
  rope_precision: 4 #No shorter than any blocks width

  joint: null
  bullet: null
  
  init: ->
    @joint_last_angle = @rotation+90
    @rope = []
    @shoot_bullet()

  calculate_aim2: ->
      vec = @joint.GetAnchorB().Copy()
      vec.Subtract(@joint.GetAnchorA())
      dir = vec.angle()/(Math.PI*2)*360
      dir = (dir + 360) % 360
      if dir < @aim
        dir = @aim
      else if dir > 270
        dir = @aim
      else if dir > 180-@aim
        dir = 180-@aim
      @aim2 = dir

  dis_joint: (p) ->
    p = p.Copy()
    p.divide(16)
    jointDef = new b2DistanceJointDef()
    jointDef.Initialize(@world.physics.solid, @body, p, @body.GetWorldCenter())
    jointDef.collideConnected = true
    @joint = @world.physics.world.CreateJoint(jointDef)

  dis_joint_off: ->
    @calculate_aim2()
    @world.physics.world.DestroyJoint(@joint)
    @joint = null

  ray_shoot: (p) ->
    input = new b2RayCastInput(new b2Vec2(@x/16,@y/16),new b2Vec2(p.x/16,p.y/16))
    output = new b2RayCastOutput()

    b = @world.physics.world.GetBodyList()
    while b
      f = b.GetFixtureList()
      while f
        if f.GetType()
          if f.RayCast(output,input,b.GetTransform())
            p = input.p1.to(input.p2)
            x2 = @x+p.x*16*output.fraction
            y2 = @y+p.y*16*output.fraction
            return new b2Vec2(x2,y2)
        f = f.GetNext()
      b = b.GetNext()

  triangle_check: (p1,p2,p3) ->
    b = @world.physics.world.GetBodyList()
    while b
      f = b.GetFixtureList()
      while f
        center = f.GetShape().m_centroid
        if center
          if @in_triangle(new b2Vec2(center.x*16,center.y*16),p1,p2,p3)
            return true
        f = f.GetNext()
      b = b.GetNext()
    return false

  in_triangle: (p,p1,p2,p3) ->
    alpha = ((p2.y - p3.y)*(p.x - p3.x) + (p3.x - p2.x)*(p.y - p3.y)) / ((p2.y - p3.y)*(p1.x - p3.x) + (p3.x - p2.x)*(p1.y - p3.y))
    beta = ((p3.y - p1.y)*(p.x - p3.x) + (p1.x - p3.x)*(p.y - p3.y)) / ((p2.y - p3.y)*(p1.x - p3.x) + (p3.x - p2.x)*(p1.y - p3.y))
    gamma = 1 - alpha - beta
    return alpha>0 && beta>0 && gamma>0

  shoot_bullet: ->
    if not @bullet and not @joint
      @bullet = @spawn('Bullet',@x,@y)
      @bullet.direction = @aim2

  step: ->
    if hit = @touch('Fly')
      hit.destroy()

    if Keyboard.press('SPACE')
      if not @bullet
        if @joint
          @dis_joint_off()
          @rope = []
      if @bullet
        @bullet.destroy()
        @bullet = null
        @rope.length = 1

    if Keyboard.release('SPACE')
      @shoot_bullet()

    if @joint
      if Keyboard.hold('LEFT')
        @body.ApplyImpulse(new b2Vec2(-@speed,0),@body.GetWorldCenter())
      if Keyboard.hold('RIGHT')
        @body.ApplyImpulse(new b2Vec2(@speed,0),@body.GetWorldCenter())
      if Keyboard.hold('DOWN')
        @joint.SetLength(@joint.GetLength()+@crawl_speed)
      if Keyboard.hold('UP')
        if @joint.GetLength() > 0.3
          @joint.SetLength(@joint.GetLength()-@crawl_speed)

    super()
    if Keyboard.press('F')
      console.log @bullet, @joint, @rope

    if @bullet
      @rope[0] = new b2Vec2(@bullet.x,@bullet.y)
      @rope.length = 2
      if hit = @ray_shoot(@rope[0])
        @bullet.destroy()
        @bullet = null
        @dis_joint(hit)
        @rope[0] = new b2Vec2(hit.x,hit.y)

    if @joint
      t0 = new b2Vec2(@x,@y)
      t1 = @rope[@rope.length-2].closer_to(t0,@rope_precision)
      
      # New knot
      if hit = @ray_shoot(t1)
        @rope[@rope.length-1] = hit
        @rope.length += 1
        @world.physics.world.DestroyJoint(@joint)
        @joint = null
        @dis_joint(hit)

      # Remove knot
      if @rope.length > 2
        t2 = @rope[@rope.length-3].closer_to(t0,@rope_precision)
        if not hit = @ray_shoot(t2)
          if not @triangle_check(t0,t1,t2)
            @rope.pop()
            @world.physics.world.DestroyJoint(@joint)
            @joint = null
            @dis_joint(@rope[@rope.length-2])

  draw: ->
    if @joint
      vec = @joint.GetAnchorB().Copy()
      vec.Subtract(@joint.GetAnchorA())
      @rotation = 90-vec.angle()/(Math.PI*2)*360
    else
      @rotation = @aim2-90

    super()
    @rope[@rope.length-1] = new b2Vec2(@x,@y)
    for i in [0..@rope.length-1]
      knot = @rope[i]
      if knot
        if i > 0
          @art.line(pknot.x,pknot.y,knot.x,knot.y)
        pknot = knot

  destroy: ->
    if @joint
      @world.physics.world.DestroyJoint(@joint)
    if @bullet
      @bullet.destroy()
    super()
