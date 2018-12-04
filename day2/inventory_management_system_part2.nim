import streams, strutils, tables

when isMainModule:
  var
    fs = newFileStream("input.txt", fmRead)
    line = ""
    text: seq[string]

  if not isNil(fs):
    while fs.readLine(line):
      text.add(line)

  block checker:
    for item in text:
      for other_item in text:
        let dist = editDistance(item, other_item)
        if dist == 1:
          echo item
          echo other_item

          var final: seq[char]
          for c in item:
            if c in other_item:
              final.add(c)
          echo final.join("")
          break checker
  
