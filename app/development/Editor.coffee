class Editor
  grid: null
  builder: null
  world: null
  level: ''

  entity_selector: null

  pause_button: null

  grid_x: null
  grid_y: null
  grid_width: null
  grid_height: null
  grid_toggle: null

  constructor:(world) ->
    @world = world
    @builder = new Builder(this)
    @grid = new Grid
    @grid.art = @world.art

    # el = document.getElementsByTagName("canvas")[0]
    # el.addEventListener "touchstart", Keyboard.touch_start, false
    # el.addEventListener "touchend", Keyboard.touch_end, false
    # el.addEventListener "touchcancel", Keyboard.touch_end , false
    # el.addEventListener "touchleave", Keyboard.touch_end, false
    # el.addEventListener "touchmove", Keyboard.touch_move, false

    @level_selector = document.getElementById("level_selector")
    @level_selector.addEventListener "change", @level_change, false
    @level_change()

    @save_type_selector = document.getElementById("save_type_selector")
    @save_type_selector.addEventListener "change", @save_type_change, false

    @save_button = document.getElementById("save_button")
    @save_button.addEventListener "click", @save, false

    @entity_selector = document.getElementById("entity_selector")
    @entity_selector.addEventListener "change", @entity_change, false
    @entity_change()

    @pause_button = document.getElementById("pause_toggle")
    @pause_button.addEventListener "click", @toggle_pause, false
    @pause_button.addEventListener "click", @entity_change, false

    @debug_draw_checkbox = document.getElementById("debug_draw_checkbox")
    @debug_draw_checkbox.addEventListener "change", @debug_draw_change, false

    @grid_x= document.getElementById("grid_x")
    @grid_y= document.getElementById("grid_y")
    @grid_width= document.getElementById("grid_width")
    @grid_height= document.getElementById("grid_height")
    @grid_toggle= document.getElementById("grid_toggle")

    @grid_x.addEventListener "change", @grid_move, false
    @grid_y.addEventListener "change", @grid_move, false
    @grid_width.addEventListener "change", @grid_move, false
    @grid_height.addEventListener "change", @grid_move, false
    @grid_toggle.addEventListener "click", @toggle_grid, false

  step: ->
    @builder.step()

  level_change: =>
    @level = @level_selector.value
    @world.destroy_all()
    @world.load_level(@level)

  save_type_change: =>
    @builder.save_type = @save_type_selector.value

  debug_draw_change: =>
    @world.physics.visible = @debug_draw_checkbox.checked

  save: =>
    level = @level_selector.value
    txt = @builder.output_level(level)
    blob = new Blob([txt], {type : 'text/html'})
    saveAs(blob,"#{level}.coffee")

  entity_change: =>
    @builder.entity = @entity_selector.value
    
  grid_move: =>
    @grid.x = parseInt @grid_x.value
    @grid.y = parseInt  @grid_y.value
    @grid.width = parseInt @grid_width.value
    @grid.height = parseInt @grid_height.value

  toggle_grid: =>
    if @grid.visible
      @grid.visible = false
    else
      @grid.visible = true

  toggle_pause: =>
    @set_pause(!Game.pause)

  set_pause: (pause) =>
    Game.pause = pause
    if pause
      @pause_button.innerHTML = 'Play'
    else
      @pause_button.innerHTML = 'Pause'
    for world in Game.worlds
      world.pause = Game.pause

  draw: ->
    @grid.draw()
