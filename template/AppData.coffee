class AppData
  @game_name = "template"
  @width = 640
  @height = 480
  @scale = 1
  @grid_on = false
  @physics = true
  @physics_pixel_per_meter = 16
  @start_level = 'Menu'
  @anti_aliasing = 'false'
  @entities:
   'Announcer': Announcer
   'Block': Block
   'Bullet': Bullet
   'Button': Button
   'Fly': Fly
   'GameController': GameController
   'Menu_1D': Menu_1D
   'Menu_2D': Menu_2D
   'Spider': Spider
   'Storage': Storage
   'Tutorial': Tutorial
   'Web': Web
  @sprites:
   'Background': 'Background.png'
   'Block': 'Block.svg'
   'Bullet': 'Bullet.png'
   'Button': 'Button.svg'
   'Flare': 'Flare.svg'
   'Fly': 'Fly.svg'
   'Marker': 'Marker.svg'
   'Marker_square': 'Marker_square.svg'
   'PlaceHolder': 'PlaceHolder.png'
   'Spider': 'Spider.svg'
   'Spider_Menu': 'Spider_Menu.svg'
   'Web': 'Web.svg'
  @levels:
   'Level': Level
   'Level10': Level10
   'Level11': Level11
   'Level2': Level2
   'Level3': Level3
   'Level4': Level4
   'Level5': Level5
   'Level6': Level6
   'Level7': Level7
   'Level8': Level8
   'Level9': Level9
   'Menu': Menu

