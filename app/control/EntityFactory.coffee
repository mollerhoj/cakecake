class EntityFactory

  spawn: (name,x=0,y=0) ->
    #Load entity
    cl = AppData.entities[name]
    if cl == undefined or not cl instanceof Entity
      console.log "Error: #{name} not found"

    #Set entity values
    entity = new cl
    entity.world = this
    entity.start_x = x
    entity.start_y = y

    #set name
    if entity.name == null
      entity.name = name

    #set sprite
    if entity.sprite == null
      if !Game.images[name]
        name = 'PlaceHolder'
      entity.sprite = new Sprite(name)

    #set size
    if entity.width == undefined
      entity.width = entity.sprite.width
    if entity.height == undefined
      entity.height = entity.sprite.height
    if entity.radius == undefined
      entity.radius = (entity.width+entity.height)/4

    #set art
    entity.art = @art

    #set physics
    if AppData.physics
      if entity.physics
        entity.body = @physics.build_dynamic(x,y,entity.width,entity.height,entity.radius,entity.physics)
        entity.body.SetUserData(entity)

    @_entities.push (entity)
    entity.reset()

    #Set start value
    entity.start_width = entity.width
    entity.start_height = entity.height
    entity.start_radius = entity.radius
    entity.start_x = entity.x
    entity.start_y = entity.y
    entity.start_angle = entity.angle

    #call init script
    entity.init()

    return entity
