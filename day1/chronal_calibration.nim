import streams, strutils, tables

when isMainModule:
  var 
    fs = newFileStream("./day1/input.txt", fmRead)
    counter: int
    line = ""
    lines: seq[int]

  if not isNil(fs):
    while fs.readLine(line):
      let parsed = parseInt(line)
      counter += parsed
      lines.add(parsed)

  echo "Part 1: ", counter

  counter = 0
  var 
    s = initTable[int, bool]()
    attemptNumber = 0

  proc attempt(): bool =
    attemptNumber += 1
    if attemptNumber %% 10 == 0:
      echo "Attempt: ", attemptNumber
    for line in lines:
      counter += line
      if s.hasKey(counter):
        echo "Part 2: ", counter
        return true
      s[counter] = true
    return false
  
  while not attempt():
    discard 