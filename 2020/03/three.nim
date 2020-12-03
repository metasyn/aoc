import strutils

let
  lines = readFile("input").string.splitLines()
  depth = lines.len
  width = lines[0].len

proc treeHits(right: int, down: int): int =
  var x, y = 0
  while y <= depth:
    try:
      if lines[y][x mod width] == '#':
        result += 1
      y += down
      x += right

    except:
      break

echo "one"
echo treeHits(3, 1)

echo "two"
echo treeHits(1, 1) * treehits(3, 1) * treeHits(5, 1) * treeHits(7, 1) *
    treeHits(1, 2)
