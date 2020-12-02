import strutils

let lines = readFile("input").string.splitLines()

var validOne = 0
var validTwo = 0

for line in lines:
  let pieces = line.split()
  if pieces.len < 3:
    continue

  let
    lowHigh = pieces[0].split("-")
    low = lowHigh[0].parseInt
    high = lowHigh[1].parseInt
    target = pieces[1][0]
    password = pieces[2]
    count = password.count(target)

  if count <= high and count >= low:
    validOne += 1

  let
    passLen = password.len
    lowIdx = low - 1
    highIdx = high - 1


  # If we don't even have the low index, there can't be a higher one
  if passLen >= low:
    let lowMatch = password[lowIdx]

    # If high is greater than len, low must match
    if passLen < high:
      if lowMatch == target:
        validTwo += 1

    else:
      let highMatch = password[highIdx]
      if lowMatch == target xor highMatch == target:
        validTwo += 1

echo validOne
echo validTwo



