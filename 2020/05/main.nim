import math
import strutils
import algorithm

let lines = readFile("input").string.splitLines()

proc splitRows(s: string): tuple[rows: string, columns: string] =
  let a = s[0 ..< ^3]
  let b = s[^3 ..< s.len]

  return (rows: a, columns: b)

proc bsp(s: string, upperChar: char): int =
  let exponent = s.len - 1
  for idx, char in s.pairs:
    let value = 2^(exponent - idx)
    if char == upperChar:
      result += value

proc bspRow(s: string): int =
  return bsp(s, 'B')

proc bspColumn(s: string): int =
  return bsp(s, 'R')

var highestOne: int
var ids = newSeq[int]()
for line in lines:
  if line.len > 0:
    let (rows, columns) = line.splitRows
    let value = (rows.bspRow * 8) + columns.bspColumn
    ids.add(value)
    if value > highestOne:
      highestOne = value

echo "one"
echo highestOne

let sorted = ids.sorted

block search:
  for idx, item in sorted.pairs:
    if sorted[idx + 1] - sorted[idx] != 1:
      echo "two"
      echo sorted[idx + 1] - 1
      break search
