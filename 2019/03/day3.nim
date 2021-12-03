import strutils
import tables

discard """
Psuedo:
  for item
    for each point in direction
      calculate coordinate, store with counter
        if value greater than 1
          calcluate distance + track
            give minimum
"""

type
  Coordinate = tuple 
    x: int
    y: int

when isMainModule:
  let contents = readFile("input.txt")
  let split = contents.split({',', '\n', '\c'})

  # Todo
  # split on new line, then update table for both wires

  var table = initCountTable[Coordinate]()

  var 
    x: int
    y: int


  var minimum = 2 shl 32
  var winner: Coordinate

  for item in split:
    if item.len < 4:
      continue


    let
      direction = item[0]
      distance = item[1..3].parseInt
    case direction
      of 'R':
        for i in x..x+distance:
          table.inc((i, y))
        x += distance
      of 'U':
        for i in y..y+distance:
          table.inc((x, i))
        y += distance
      of 'L':
        for i in x..x-distance:
          table.inc((i, y))
        x -= distance
      of 'D':
        for i in y..y-distance:
          table.inc((x, i))
        y -= distance
      else:
        discard

  for (key, value) in table.pairs:
    if value >= 2:
      let dist = key.x.abs + key.y.abs
      if dist < minimum and dist >= 1:
        echo dist
        minimum = dist
        winner = key

  echo minimum
  echo winner


          


  


