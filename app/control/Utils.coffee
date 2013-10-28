# A Utils file
# Below is baseclass extensions
# Might also have a class with helpful methods (sign?)
Array::remove = (e) ->
  @[t..t] = [] if (t = @indexOf(e)) > -1

Array::diff = (a) ->
  @filter (i) ->
    not (a.indexOf(i) > -1)

# Return a copy of the array
Array::copy = ->
  this.slice(0)

Array::unique = ->
  @sort().filter (v, i, o) ->
    (if i and v isnt o[i - 1] then v else 0)

Math.distance_2d = (x1,y1,x2,y2) ->
  return Math.sqrt(Math.pow(x1-x2,2)+Math.pow(y1-y2,2))

Math.sign = (n) ->
  return (if n > 0 then 1 else (if n < 0 then -1 else 0))

Math.generate_unique = (length=8) ->
  id = ""
  id += Math.random().toString(36).substr(2) while id.length < length
  id.substr 0, length

 #Should be removed when not in browser
 Audio.muted = false
 
 Audio::go = () ->
   if Audio.muted == false
     this.play()
