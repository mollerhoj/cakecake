var PTM = 16; // 32 pixel = 1 meter
var world = null;
var canvas;
var context;
var myDebugDraw;        
var frameTime60 = 0;
var currentTest = null;

function startup() {
  init()
  createWorld()
  animate();
}
        
function init() {
    canvas = document.getElementById("canvas");
    context = canvas.getContext( '2d' );
    myDebugDraw = getCanvasDebugDraw();            
    myDebugDraw.SetFlags(e_shapeBit);
}


function createWorld() {
    world = new b2World( new b2Vec2(0.0, -10.0) );
    world.SetDebugDraw(myDebugDraw);

    //Body of all solids
    solid = world.CreateBody(new b2BodyDef());
    
    //Ground
    var ground = new b2EdgeShape();
    ground.Set(new b2Vec2(0.0, -15), new b2Vec2(canvas.width/PTM, -15));
    solid.CreateFixture(ground, 0.0);
    
    //Solids
    var shape = new b2PolygonShape();
    shape.SetAsBox(6.0, 0.25, new b2Vec2(10-1.5, -5), 0);
    solid.CreateFixture(shape, 0.0);
    
    shape.SetAsBox(7.0, 0.25, new b2Vec2(10+1.0, -9), 0.3);
    solid.CreateFixture(shape, 0.0);
    
    shape.SetAsBox(0.25, 1.5, new b2Vec2(10+-7.0, -11), 0.0);
    solid.CreateFixture(shape, 0.0);

    //Dominos
    shape = new b2PolygonShape();
    shape.SetAsBox(0.1, 1.0);

    var fd = new b2FixtureDef();
    fd.set_shape(shape);
    fd.set_density(20.0);
    fd.set_friction(0.1);

    for (var i = 0; i < 10; ++i)
    {
        var bd = new b2BodyDef();
        bd.set_type(b2_dynamicBody);
        bd.set_position(new b2Vec2(10-6.0 + 1.0 * i, 11.25-15));
        var body = world.CreateBody(bd);
        body.CreateFixture(fd);
    }

    //Pendulum
    var shape = new b2PolygonShape();
    shape.SetAsBox(0.25, 0.25);

    var bd = new b2BodyDef();
    bd.set_type(b2_dynamicBody);
    bd.set_position(new b2Vec2(0,0));
    var b4 = world.CreateBody(bd);
    b4.CreateFixture(shape, 10.0);
    
    var jd = new b2RevoluteJointDef();
    var anchor = new b2Vec2(10-2.0, 1.0-15);
    anchor.Set(10-7.0,0);
    jd.Initialize(solid, b4, anchor);
    world.CreateJoint(jd);
}

function step(timestamp) {
    
    if ( currentTest && currentTest.step ) 
        currentTest.step();
    
    var current = Date.now();
    world.Step(1/60, 3, 2);
    var frametime = (Date.now() - current);
    frameTime60 = frameTime60 * (59/60) + frametime * (1/60);
    draw();
}

function draw() {

    
    //black background
    context.fillStyle = 'rgb(0,0,0)';
    context.fillRect( 0, 0, canvas.width, canvas.height );
    
    context.save();            
        context.translate(0,0);
        context.scale(1,-1);                
        context.scale(PTM,PTM);
        context.lineWidth /= PTM;
        
        drawAxes(context);
        
        context.fillStyle = 'rgb(255,255,0)';
        world.DrawDebugData();
        
    context.restore();
}

window.requestAnimFrame = (function(){
    return  window.requestAnimationFrame       || 
            window.webkitRequestAnimationFrame || 
            window.mozRequestAnimationFrame    || 
            window.oRequestAnimationFrame      || 
            window.msRequestAnimationFrame     || 
            function( callback ){
              window.setTimeout(callback, 1000 / 60);
            };
})();

function animate() {
    requestAnimFrame( animate );
    step();
}
