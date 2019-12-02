import strutils, sugar, sequtils, math, strutils


func compute(x: float): int =
    result = int(floor(x / 3.0) - 2)

func compute(x: int): int =
  result = compute(x.float)

func compute(x: string): int =
  if x.len > 0:
    result = compute(parseFloat(x))
  else:
    result = 0

func computeWithFuel(x: string): int =
  var values = newSeq[int]()
  var fuel = compute(x)
  values.add(fuel)
  while fuel >= 0:
    fuel = compute(fuel)
    if fuel > 0:
      values.add(fuel)
  result = sum(values)

when isMainModule:
  let input = readFile("./input.txt").string.splitLines
  echo "part 1"
  echo sum(input.map(x => compute(x)))

  echo "part 2"
  echo sum(input.map(x => computeWithFuel(x)))
