class GameController extends Entity
  @score: 0
  text: null
  world: null
  date: 0
  
  init: ->
    @text = new Text('10',10,10)
    @text.align = 'left'

    @createWorld()

  createWorld: ->
    
    #Dominos
    shape = new b2PolygonShape()
    shape.SetAsBox 0.1, 1.0
    fd = new b2FixtureDef()
    fd.set_shape shape
    fd.set_density 20.0
    fd.set_friction 0.1
    i = 0

    while i < 10
      bd = new b2BodyDef()
      bd.set_type b2_dynamicBody
      bd.set_position new b2Vec2(10 - 6.0 + 1.0 * i, 2)
      body = @world.physics.world.CreateBody(bd)
      body.CreateFixture fd
      ++i
    
    #Pendulum
    shape = new b2PolygonShape()
    shape.SetAsBox 0.25, 0.25
    bd = new b2BodyDef()
    bd.set_type b2_dynamicBody
    bd.set_position new b2Vec2(0, 0)
    b4 = @world.physics.world.CreateBody(bd)
    b4.CreateFixture shape, 10.0
    jd = new b2RevoluteJointDef()
    anchor = new b2Vec2(10 - 2.0, 1.0 - 15)
    anchor.Set 10 - 7.0, 0
    jd.Initialize @world.physics.solid, b4, anchor
    @world.physics.world.CreateJoint jd

  draw: ->
    tmp_date = new Date
    sec =  tmp_date-@date
    @date = tmp_date
    @text.string = sec
    @text.draw()

