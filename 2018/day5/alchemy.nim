import strutils
import ../util


func surrogate(a, b: char): bool =
  result = false
  if a.toUpperAscii == b.toUpperAscii:
    result = isUpperAscii(a) xor isUpperAscii(b)

proc react(s: var string): int =
  var i: int
  while i < len(s) - 1:
    let 
      x = s[i]
      y = s[i + 1]
    if surrogate(x, y):
      s.delete(i, i+1)
      i = max(0, i - 1)
    else:
      i += 1
  result = len(s)


proc remove(s: string, a: char): string =
  let b =  "" & a
  let 
    upper = b.toUpperAscii()
  result = s.replace(b)
  result = result.replace(upper)

when isMainModule:
  var input = getInput(5)[1]
  var part1 = react(input)
  echo "part 1: ", part1
  var min = part1
  for letter in 'a'..'z':
    var removed  = input.remove(letter) 
    let length = react(removed)
    if length < min:
      min = length
  echo "part 2: ",  min