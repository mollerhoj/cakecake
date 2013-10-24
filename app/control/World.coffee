# ## World
# The World class manages the game world and what can be seen
# by the player.
class World
  _entities: []
  _entities_to_destroy: [] #entites must wait to be destroyed
  x: 0
  y: 0
  pause: false
  physics: null
  art: null
  background: null
  current_level: ''
  current_level_n: -1

  constructor: ->
    @background = new Sprite('Background',AppData.width/2,AppData.height/2)
    if AppData.physics
      @physics = new Physics
    @art = new Art(this)

  next_level: =>
    if @current_level_n == -1
      console.log "Error: Level number not set, can't go to next"
    else
      @change_level(@current_level,@current_level_n+1)

  change_level: (name,index=1) ->
    @destroy_all()
    @load_level(name,index)

  load_level: (name,index=1) ->
    if index != 1
      name = name.replace /\d/, ""
      name = name+index
    @current_level = name
    @current_level_n = index
    level = AppData.levels[name]
    if level == undefined
      console.log "Error: #{name} not found"
    for number,dataobject of level.data
      s = @spawn(dataobject.name,dataobject.x,dataobject.y)
      for property, value of dataobject
        s[property] = value
      if dataobject.rotation
        s.set_rotation(dataobject.rotation)
      if dataobject.w
        s.set_w(dataobject.w)
      if dataobject.h
        s.set_h(dataobject.h)

  # reset
  reset: ->
    @destroy_all()
    @load_level(@current_level)

  destroy: (entity) ->
    @_entities_to_destroy.push entity

  destroy_all: ->
    for e in @_entities
      e.destroy()
    
  all_entities: ->
    return @_entities

  # Spawn new
  spawn: (name,x = 0,y = 0) ->
    #Load entity
    cl = AppData.entities[name]
    if cl == undefined or not cl instanceof Entity
      console.log "Error: #{name} not found"

    #Set entity values
    entity = new cl
    entity.world = this
    entity.sx = x
    entity.sy = y

    #set name
    if entity.name == null
      entity.name = name

    #set sprite
    if entity.sprite == null
      if !Game.images[name]
        name = 'PlaceHolder'
      entity.sprite = new Sprite(name)

    #set size
    if entity.w == undefined
      entity.w = entity.sprite.w
    if entity.h == undefined
      entity.h = entity.sprite.h
    if entity.r == undefined
      entity.r = (entity.w+entity.h)/4

    #set art
    entity.art = @art

    #set physics
    if AppData.physics
      if entity.physics
        entity.body = @physics.build_dynamic(x,y,entity.w,entity.h,entity.r,entity.physics)
        entity.body.SetUserData(entity)

    @_entities.push (entity)
    entity.reset()
    entity.init()
    return entity

  entities_of_class: (c) ->
    res = []
    for entity in @_entities
      if entity.name == c then res.push(entity)
    return res
      
  number_of: (c) ->
    return @entities_of_class(c).length

  exists: (c) ->
    return @number_of(c) > 0

  # Draw all the _entities
  draw: ->
    #Draw background
    @art.color '#EFF8FB'
    @art.rectangleC 0,0,AppData.width * AppData.scale / Game.zoom_level,AppData.height * AppData.scale / Game.zoom_level,true
    @art.color '#000000'

    @background.draw()

    if @physics
      @physics.draw(@x,@y)

    #Sort for z values. not tested.
    @_entities.sort (a,b) ->
      return if Math.sign(a.z-b.z)==0 then Math.sign(a.y-b.y) else Math.sign(a.z-b.z)
    
    #Draw all entities
    for entity in @_entities
      entity.draw()

  # Step for all _entities
  step:   ->
    Keyboard.step()
   
    if @pause == false
      @physics.world.Step(1/120, 3, 2);
      for entity in @_entities
        if typeof entity.step is "function"
          entity.step()

    @_remove_destroyed()

  #private

  _remove_destroyed: ->
    for e in @_entities_to_destroy
      @_entities.remove e
    @_entities_to_destroy = []
