class Tutorial extends Entity
  text: null
  index: 0
  instructions1: [
    "Press and hold left and right arrowkey to swing.",
    "Press and hold up arrowkey to crawl web.",
    "Press and hold down arrowkey to spin web.",
    "Press and hold the space bar to free fall.",
    "Swing, crawl, spin and shoot web to move around.",
    "Catch the fly in each level to win.",
    ""]
  instructions2: [
    "Catch the fly!",
    "",
    "",
    "Release the space bar to shoot web!",
    "You have no control when free falling.",
    "Good Luck!",
    ""]

  init: ->
    @text = new Text(@instructions1[0],AppData.width/2,30)
    @text.font_size = 20
    @text.font = 'Norwester'
    @text2 = new Text(@instructions2[0],AppData.width/2,68)
    @text2.font_size = 40
    @text2.font = 'Norwester'

  fly_taken:(callback) =>
    @index+=1
    @text.string = @instructions1[@index]
    @text2.string = @instructions2[@index]
    if @index == 1
      @world.spawn('Fly',300,200)
    if @index == 2
      @world.spawn('Fly',300,280)
    if @index == 3
      @world.spawn('Fly',540,340)
      @text.font_size = 30
      @text2.font_size = 20
    if @index == 4
      @text.font_size = 18
      @text2.font_size = 30
      @world.spawn('Fly',100,220)
    if @index == 5
      @world.spawn('Fly',500,230)
      @text.font_size = 20
      @text2.font_size = 40
    if @index > 5
      callback()


  draw: ->
    @text.draw()
    @text2.draw()
