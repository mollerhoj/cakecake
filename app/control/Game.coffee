# ## Game
# The game class handles top level game loop and initialisation.
class Game
  @context = null
  @worlds = []
  @images = {}
  @zoom_level: 1
  @pause = false
  @editor = null
  @mode = ""

  @add_world: ->
    w = new World
    Game.worlds.push(w)
    return w

  @init:(mode) ->
    @mode = mode
    #Create canvas:
    Game.context = Game.create_canvas()

    #Adjust zoom level:
    Game.set_zoom(AppData.scale)

    Game.setup_keyboard()

    #Load Art
    i = new ImageLoader()
    i.onload = Game.start
    i.load_images()
    
  @start: =>
    #Create a world
    w = Game.add_world()

    w.load_level(AppData.start_level)

    #Create editor
    if @mode=="build"
      Game.editor = new Editor(Game.worlds[0])

    #Start running
    setInterval(Game.run, 16)

  @set_zoom: (rate) ->
    Game.context.scale(rate/Game.zoom_level,rate/Game.zoom_level)
    Game.zoom_level = rate

  # To own load images class
  @create_canvas: ->
    canvas = document.createElement("canvas")
    canvas.width = AppData.width * AppData.scale
    canvas.height = AppData.height * AppData.scale
    document.body.appendChild canvas
    context = canvas.getContext("2d")
    context.textBaseline = 'top'
    context.imageSmoothingEnabled = false # Spec
    context.mozImageSmoothingEnabled = false # Mozilla
    context.webkitImageSmoothingEnabled = false # Chrome / Safari
    return context

  @setup_keyboard: ->
    canvas = document.getElementsByTagName("canvas")[0]
    document.body.onkeydown = =>
      Keyboard.key_pressed(event.keyCode)
    document.body.onkeyup = =>
      Keyboard.key_released(event.keyCode)
    canvas.onmousemove = =>
      Keyboard.mouse_move(event)
    canvas.onmousedown = =>
      Keyboard.mouse_down(event.which)
    canvas.onmouseup = =>
      Keyboard.mouse_up(event.which)
    canvas.oncontextmenu = => return false #remove right-click menu
    canvas.addEventListener "touchstart", Keyboard.touch_start, false
    canvas.addEventListener "touchend", Keyboard.touch_end, false
    canvas.addEventListener "touchcancel", Keyboard.touch_end , false
    canvas.addEventListener "touchleave", Keyboard.touch_end, false
    canvas.addEventListener "touchmove", Keyboard.touch_move, false

  @run: =>
    for world in Game.worlds
      world.step()
      world.draw()

    if Game.editor
      Game.editor.step()
      Game.editor.draw()
