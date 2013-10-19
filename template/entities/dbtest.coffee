class dbtest extends Entity

setColorFromDebugDrawCallback = (color) ->
  col = Box2D.wrapPointer(color, b2Color)
  red = (col.get_r() * 255) | 0
  green = (col.get_g() * 255) | 0
  blue = (col.get_b() * 255) | 0
  colStr = red + "," + green + "," + blue
  Game.context.fillStyle = "rgba(" + colStr + ",0.5)"
  Game.context.strokeStyle = "rgb(" + colStr + ")"

drawSegment = (vert1, vert2) ->
  vert1V = Box2D.wrapPointer(vert1, b2Vec2)
  vert2V = Box2D.wrapPointer(vert2, b2Vec2)
  Game.context.beginPath()
  Game.context.moveTo vert1V.get_x(), vert1V.get_y()
  Game.context.lineTo vert2V.get_x(), vert2V.get_y()
  Game.context.stroke()

drawPolygon = (vertices, vertexCount, fill) ->
  Game.context.beginPath()
  tmpI = 0
  while tmpI < vertexCount
    vert = Box2D.wrapPointer(vertices + (tmpI * 8), b2Vec2)
    if tmpI is 0
      Game.context.moveTo vert.get_x(), vert.get_y()
    else
      Game.context.lineTo vert.get_x(), vert.get_y()
    tmpI++
  Game.context.closePath()
  Game.context.fill()  if fill
  Game.context.stroke()

drawCircle = (center, radius, axis, fill) ->
  centerV = Box2D.wrapPointer(center, b2Vec2)
  axisV = Box2D.wrapPointer(axis, b2Vec2)
  Game.context.beginPath()
  Game.context.arc centerV.get_x(), centerV.get_y(), radius, 0, 2 * Math.PI, false
  Game.context.fill()  if fill
  Game.context.stroke()
  if fill
    
    #render axis marker
    vert2V = copyVec2(centerV)
    vert2V.op_add scaledVec2(axisV, radius)
    Game.context.beginPath()
    Game.context.moveTo centerV.get_x(), centerV.get_y()
    Game.context.lineTo vert2V.get_x(), vert2V.get_y()
    Game.context.stroke()

drawTransform = (transform) ->
  trans = Box2D.wrapPointer(transform, b2Transform)
  pos = trans.get_p()
  rot = trans.get_q()
  Game.context.save()
  Game.context.translate pos.get_x(), pos.get_y()
  Game.context.scale 0.5, 0.5
  Game.context.rotate rot.GetAngle()
  Game.context.lineWidth *= 2
  drawAxes Game.context
  Game.context.restore()

getCanvasDebugDraw = () ->
  debugDraw = new Box2D.b2Draw()
  Box2D.customizeVTable debugDraw, [
    original: Box2D.b2Draw::DrawSegment
    replacement: (ths, vert1, vert2, color) ->
      setColorFromDebugDrawCallback color
      drawSegment vert1, vert2
  ]
  Box2D.customizeVTable debugDraw, [
    original: Box2D.b2Draw::DrawPolygon
    replacement: (ths, vertices, vertexCount, color) ->
      setColorFromDebugDrawCallback color
      drawPolygon vertices, vertexCount, false
  ]
  Box2D.customizeVTable debugDraw, [
    original: Box2D.b2Draw::DrawSolidPolygon
    replacement: (ths, vertices, vertexCount, color) ->
      setColorFromDebugDrawCallback color
      drawPolygon vertices, vertexCount, true
  ]
  Box2D.customizeVTable debugDraw, [
    original: Box2D.b2Draw::DrawCircle
    replacement: (ths, center, radius, color) ->
      setColorFromDebugDrawCallback color
      dummyAxis = b2Vec2(0, 0)
      drawCircle center, radius, dummyAxis, false
  ]
  Box2D.customizeVTable debugDraw, [
    original: Box2D.b2Draw::DrawSolidCircle
    replacement: (ths, center, radius, axis, color) ->
      setColorFromDebugDrawCallback color
      drawCircle center, radius, axis, true
  ]
  Box2D.customizeVTable debugDraw, [
    original: Box2D.b2Draw::DrawTransform
    replacement: (ths, transform) ->
      drawTransform transform
  ]
  debugDraw
