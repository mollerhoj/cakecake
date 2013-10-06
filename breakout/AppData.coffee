class AppData
  @game_name = "breakout"
  @width = 320
  @height = 240
  @scale = 2
  @grid_on = false
  @entities:
   'Ball': Ball
   'Pad': Pad
  @sprites:
   'Ball': 'Ball.png'
   'Brick': 'Brick.png'
   'Pad': 'Pad.png'
   'PlaceHolder': 'PlaceHolder.png'
  @levels:
   'Level': Level
   'Level2': Level2
   'Level3': Level3

