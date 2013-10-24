class Builder
  active: true
  hold: false
  entity: null
  world: null
  grid: null
  editor: null

  constructor:(editor) ->
    @editor = editor
    #Ugly but don't know how else:
    @world = Game.worlds[0]

  output_level:(name) ->
    txt = "class #{name}\n  @data:\n"
    level = AppData.levels[name]
    n = Object.keys(level.data).length
    for i in [1..n]
      e = level.data[i]
      txt += "    #{i}:\n"
      txt += "      name: '#{e.name}'\n"
      txt += "      x: #{e.x}\n"
      txt += "      y: #{e.y}\n"
      txt += "      rotation: #{e.rotation}\n"
      txt += "      w: #{e.w}\n"
      txt += "      h: #{e.h}\n"
    return txt

  save_level:(name) ->
    i = 1
    level = AppData.levels[name]
    level.data = new Object()
    for e in @world.all_entities()
      o = new Object()
      o.name = e.name
      o.x = e.sx
      o.y = e.sy
      o.rotation = e.rotation
      o.w = e.w
      o.h = e.h
      level.data[i] = o
      i += 1

  step: ->
    #Ugly but don't know how else:
    if not @grid
      @grid = Game.editor.grid

    if not @active then return
    if !Game.pause then return
    
    # Create objects
    if Keyboard.press('MOUSE_LEFT')
      @hold = @world.spawn(@entity,Keyboard.MOUSE_X,Keyboard.MOUSE_Y)

    # Hold objects
    if @hold
      @hold.set_x(Keyboard.MOUSE_X)
      @hold.set_y(Keyboard.MOUSE_Y)
      if Keyboard.hold('SHIFT') and @grid
        @hold.x=@hold.x - @hold.x % @grid.width+@grid.width/2
        @hold.y=@hold.y - @hold.y % @grid.height+@grid.height/2
      @hold.sx = @hold.x
      @hold.sy = @hold.y

      if Keyboard.hold('Q')
        @hold.set_rotation(@hold.rotation+1)
      if Keyboard.hold('E')
        @hold.set_rotation(@hold.rotation-1)
      if Keyboard.hold('W')
        @hold.h += 1
      if Keyboard.hold('S')
        @hold.h -= 1
      if Keyboard.hold('D')
        @hold.w += 1
      if Keyboard.hold('A')
        @hold.w -= 1

    if Keyboard.release('MOUSE_LEFT')
      @save_level(@editor.level)
      @hold = null

    # Destroy objects
    if Keyboard.hold('MOUSE_RIGHT')
      temp_all_entities = @world.all_entities().slice(0)
      for e in temp_all_entities when e.mouse_hits()
        e.destroy()
      @save_level(@editor.level)
