import strformat, strutils, algorithm

proc getInput*(d: int, file: string = "input"): seq[string] =
  let lines = readFile(fmt"day{d}/{file}.txt").string.splitLines()
  result = sorted(lines, system.cmp)

proc getSample*(d: int): seq[string] =
  result = getInput(d, file = "sample")