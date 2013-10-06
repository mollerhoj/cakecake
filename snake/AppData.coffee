class AppData
  @game_name = "snake"
  @width = 320
  @height = 480
  @scale = 2
  @grid_on = false
  @entities:
   'Apple': Apple
   'GameController': GameController
   'Snake': Snake
   'SnakeBody': SnakeBody
   'SnakeBodyShadow': SnakeBodyShadow
  @sprites:
   'Heart': 'Heart.png'
   'PlaceHolder': 'PlaceHolder.png'
   'Snake': 'Snake.png'
   'SnakeBody': 'SnakeBody.png'
   'SnakeBodyShadow': 'SnakeBodyShadow.png'
  @levels:
   'Level': Level

