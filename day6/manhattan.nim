import strutils, sequtils, algorithm, sugar, math, strformat, tables, streams
import ../util

type
  Point = tuple[x, y: int]

proc loadPoints(): seq[Point] =
  let input = getInput(6)
  result = newSeq[Point](len(input))
  for i, line in input:
    if len(line) > 0:
      let xy = line.split(", ").map(parseInt)
      result[i] = (x: xy[0], y: xy[1])

proc samplePoints(): seq[Point] =
  result = newSeq[Point]()
  result.add((1, 1))
  result.add((1, 6))
  result.add((8, 3))
  result.add((3, 4))
  result.add((5, 5))
  result.add((8, 9))

proc manhattanDistance(a: Point, b: Point): int =
  return abs(a.x - b.x) + abs(a.y - b.y)

proc nearestNeighbor(points: seq[Point], p: Point): Point =
  var minDist = 1_000_000
  var dists = newSeq[int](len(points))
  for i, point in points:
    let dist = manhattanDistance(point, p)
    dists.add(dist)
    if dist < minDist:
      minDist = dist
      result = point
  
  if dists.count(minDist) > 1:
    var p: Point
    result = p

proc getBoundingBox(points: seq[Point]): tuple[a, b: Point] =
  let n = 0 # for testing
  var 
    maxs = points[0]
    mins = points[0]

  for p in points:
    if p.x > maxs.x:
      maxs.x = p.x + n
    if p.x < mins.x:
      mins.x = p.x - n
    if p.y > maxs.y:
      maxs.y = p.y + n
    if p.y < mins.y:
      mins.y = p.y - n
    result = (maxs, mins)
  
proc onEdge(maxs, mins: Point, x, y: int): bool =
  result = (x == maxs.x or 
      x == mins.x or
      y == maxs.y or
      y == mins.y)


proc calculate(points: seq[Point]): int =
  let (maxs, mins) = getBoundingBox(points)
  var table = newTable[Point, int]()

  for y in 0..maxs.y:
    for x in 0..maxs.x:
      let neighbor = points.nearestNeighbor((x, y))
      if neighbor != (0, 0):
        discard table.hasKeyOrPut(neighbor, 1)
        table[neighbor] += 1
      if onEdge(maxs, mins, x, y):
        table.del(neighbor)
    
  result = 0
  for k, v in table.pairs:
    if v > result:
      result = v

proc calculateSafePoints(points: seq[Point], maxDist: int = 10_000): int =
  let (maxs, mins) = getBoundingBox(points)

  for y in 0..maxs.y:
    for x in 0..maxs.x:
      var sum: int
      for i, p in points:
        sum += manhattanDistance(p, (x, y))
      if sum < maxDist:
        result += 1

proc plot(points: seq[Point], neighbors: bool): string =
  let 
    (maxs, mins)= getBoundingBox(points)

  var ids = ""
  for i in 'a'..'z':
    ids.add(i) 

  for y in 0..maxs.y + 1:
    for x in 0..maxs.x + 1:
      var text = ". "

      if neighbors:
        let nearest = points.nearestNeighbor((x, y))
        for i, p in points:
          if p == nearest:
            text = fmt"{ids[i]:<2}"

      for i, p in points:
        if p.x == x and p.y == y:
          let id = ids[i].toUpperAscii()
          text = fmt"{id:<2}"
      result = result & text
    
    result = result & "\n"

        

proc sampleRun() =
  let data = samplePoints()
  assert len(data) > 0

  # Check bounding
  let (maxs, mins)= getBoundingBox(data)
  assert maxs.x == 8
  assert maxs.y == 9
  assert mins.x == 1
  assert mins.y == 1

  # Check manhattan
  assert manhattanDistance((0, 0), (3, 3)) == 6
  assert manhattanDistance((1, 2), (7, 7)) == 11

  # Check onEdge
  for item in @[
      (1, 1),
      (1, 9),
      (2, 1),
      (3, 1),
      (2, 1),
      (8, 1),
      (8, 9),
    ]:
    let (x, y) = item
    assert onEdge(maxs, mins, x, y)
  
  echo plot(data, neighbors = false)
  echo plot(data, neighbors = true)
  assert calculate(data) == 17
  assert calculateSafePoints(data, maxDist = 32) == 16

when isMainModule:
  echo "example:" 
  sampleRun()
  let points = loadPoints()
  echo "part 1: ", calculate(points)
  echo "part 2: ", calculateSafePoints(points)
