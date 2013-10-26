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
    console.log 'init'
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

    #Start drawing
    Game.draw()

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
    context.textBaseline = 'middle'
    if not AppData.anti_aliasing
      context.imageSmoothingEnabled = false # Spec
      context.mozImageSmoothingEnabled = false # Mozilla
      context.webkitImageSmoothingEnabled = false # Chrome / Safari
    return context

  @setup_keyboard: ->
    canvas = document.getElementsByTagName("canvas")[0]
    document.onkeydown = (evt) =>
      Keyboard.key_pressed(evt.keyCode)
    document.onkeyup = (evt) =>
      Keyboard.key_released(evt.keyCode)
    canvas.onmousemove = (evt) =>
      Keyboard.mouse_move(evt)
    canvas.onmousedown = (evt) =>
      Keyboard.mouse_down(evt.which)
    canvas.onmouseup = (evt) =>
      Keyboard.mouse_up(evt.which)
    canvas.oncontextmenu = => return false #remove right-click menu
    canvas.addEventListener "touchstart", Keyboard.touch_start, false
    canvas.addEventListener "touchend", Keyboard.touch_end, false
    canvas.addEventListener "touchcancel", Keyboard.touch_end , false
    canvas.addEventListener "touchleave", Keyboard.touch_end, false
    canvas.addEventListener "touchmove", Keyboard.touch_move, false

  @requestAnimFrame: (callback) ->
  window.requestAnimationFrame or
  window.webkitRequestAnimationFrame or
  window.mozRequestAnimationFrame or (callback) ->
    window.setTimeout callback, 1000 / 60

  @draw: =>
    #Game.requestAnimFrame(Game.draw)
    #
    for world in Game.worlds
      world.draw()
    requestAnimationFrame(Game.draw)

  @run: =>
    for world in Game.worlds
      world.step()

    if Game.editor
      Game.editor.step()
      Game.editor.draw()
