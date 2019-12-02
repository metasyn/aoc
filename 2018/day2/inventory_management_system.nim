import streams, strutils, tables

when isMainModule:
  var
    fs = newFileStream("input.txt", fmRead)
    line = ""
    twos: int
    threes: int

  if not isNil(fs):
    while fs.readLine(line):
      var 
        table = newCountTable[char](initialSize = rightSize(len(line)))
        two: int 
        three: int 

      for c in line:
        table.inc(c)

      block lineChecker:
        # Check if any characters occured exactly twice
       # or exactly three times 
        for k, v in pairs(table):
          if v == 2:
            two = 1 
          elif v == 3:
            three = 1
          # Can only count each once
          if two == 1 and three == 1:
            break lineChecker

      twos += two
      threes += three

  echo "twos: ", twos
  echo "threes: ", threes
  echo twos * threes
      

