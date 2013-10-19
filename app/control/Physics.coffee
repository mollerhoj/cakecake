using_physics(Box2D, "b2.+")
class Physics
  world: null
  solid: null
  PTM: 16

  constructor: ->
    @create_world()
    @setup_debug_draw()
    @solid = @world.CreateBody(new b2BodyDef())
    @build_edges()
    @build_boxes()

  create_world: ->
    @world = new b2World(new b2Vec2(0.0, 10.0))

  setup_debug_draw: ->
    myDebugDraw = getCanvasDebugDraw();            
    myDebugDraw.SetFlags(e_shapeBit);
    @world.SetDebugDraw myDebugDraw

  build_edges: ->
    @build_solid_line(0,0,AppData.width,0)
    @build_solid_line(0,AppData.height,AppData.width,AppData.height)
    @build_solid_line(0,0,0,AppData.height)
    @build_solid_line(AppData.width,0,AppData.width,AppData.height)

  build_boxes: ->
    @build_solid_box(130,60,100,4,0)

  build_solid_line: (x1,y1,x2,y2) ->
    line = new b2EdgeShape()
    line.Set new b2Vec2(x1/@PTM,y1/@PTM),new b2Vec2(x2/@PTM,y2/@PTM)
    @solid.CreateFixture line, 0.0

  build_solid_box: (x,y,w,h,rotation) ->
    box = new b2PolygonShape()
    box.SetAsBox w/@PTM, h/@PTM, new b2Vec2(x/@PTM, y/@PTM), (rotation/360)*(Math.PI*2)
    @solid.CreateFixture box, 0.0

  draw: ->
    Game.context.save();            
    Game.context.scale(@PTM,@PTM);
    Game.context.lineWidth /= @PTM;
    @world.DrawDebugData(Game.context);
    Game.context.restore();

