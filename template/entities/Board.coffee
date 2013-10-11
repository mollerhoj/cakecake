class Board extends Entity
  width: 16
  height: 16
  n: 21
  m: 14
  cells: null
  draw_cells: null

  init: ->
    @draw_cells = new Array(@n)
    for x in [0..@n]
      @draw_cells[x] = new Array(@m)

    @cells = new Array(@n)
    for x in [0..@n]
      @cells[x] = new Array(@m)

    for x in [0..@n]
      for y in [0..@m]
        @cells[x][y] = 1
        cell = new Cell(x,y)
        cell.text = new Text(0,x*@width,y*@height)
        cell.text.align = 'left'
        @draw_cells[x][y] = cell

  draw: ->
    for x in [0..@n]
      for y in [0..@m]
        @draw_cells[x][y].text.string = @cells[x][y]
        @draw_cells[x][y].draw()

  step: ->
    if Keyboard.press('SPACE')
      for p in @path([3,3],[@n-3,@m-3])
        @cells[p[0]][p[1]] += 1

  neighbors: (x,y)->
    cells = []
    if x > 0
      cells.push [x-1,y]
    if y > 0
      cells.push [x,y-1]
    if x < @n
      cells.push [x+1,y]
    if y < @m
      cells.push [x,y+1]
    return cells

  id: (c) ->
    return c[0]+c[1]*@n

  path: (start,end) ->
    pq = PriorityQueue()
    v = {}
    pq.push 0, start 
    while pq.size() > 0
      tp = pq.top_priority()
      u = pq.pop()
      for n in @neighbors(u[0],u[1])
        id = @id(n)
        if !v[id]
          v[id] = u
          pq.push tp+@cells[n[0]][n[1]], n
        if n[0] == end[0] and n[1] == end[1]
          return @_trace_back(v,start,end)
    return []

  _trace_back: (v,start,end) ->
    u = end
    res = [u]
    while(true)
      u = v[@id(u)]
      if u[0] == start[0] and u[1] == start[1]
        return res
      res.push u
  
#Only used for testing
class Cell extends Entity
  text: null
  x: 0
  y: 0

  constructor: (x,y) ->
    @x = x
    @y = y

  draw: ->
    @text.draw()

#
# http://rosettacode.org/wiki/Priority_queue#CoffeeScript
#
PriorityQueue = ->
  # Use closure style for object creation (so no "new" required).
  # Private variables are toward top.
  h = []
 
  better = (a, b) ->
    h[a].priority < h[b].priority
 
  swap = (a, b) ->
    [h[a], h[b]] = [h[b], h[a]]
 
  sift_down = ->
    max = h.length
    n = 0
    while n < max
      c1 = 2*n + 1
      c2 = c1 + 1
      best = n
      best = c1 if c1 < max and better(c1, best)
      best = c2 if c2 < max and better(c2, best)
      return if best == n
      swap n, best
      n = best
 
  sift_up = ->
    n = h.length - 1
    while n > 0
      parent = Math.floor((n-1) / 2)
      return if better parent, n
      swap n, parent
      n = parent
 
  # now return the public interface, which is an object that only
  # has functions on it
  self =
    size: ->
      h.length
 
    push: (priority, value) ->
      elem =
        priority: priority
        value: value
      h.push elem
      sift_up()
 
    pop: ->
      throw Error("cannot pop from empty queue") if h.length == 0
      value = h[0].value
      last = h.pop()
      if h.length > 0
        h[0] = last
        sift_down()
      value

    top_priority: ->
      h[0].priority
