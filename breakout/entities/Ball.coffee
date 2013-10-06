class Ball extends Entity

  speed: 4
  hdir: 0
  vdir: 0
  
  init: ->
    @hdir = Math.random()*360
    @vdir = Math.random()*360
    
  step: ->
    @move_in_direction(@hdir,@vdir,@speed)
    @outside()
    @hit_pad()

  hit_pad: ->
    hit = @hit('Pad')
    if hit
      @vdir = -Math.abs(@vdir)

  move_in_direction: (hdir,vdir,speed) ->
    @x += Math.cos(hdir/180*Math.PI)
    @y -= Math.sin(vdir/180*Math.PI)

  outside: ->
    if @x < @r
      @hdir = 180-@hdir
    if @x > 320-@r
      @hdir = 180-@hdir
    if @y < @r
      @vdir = -@vdir
    if @y > 240
      @destroy()


      
      



