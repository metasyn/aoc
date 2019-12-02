import strutils, math
import ../util

proc sampleData(): string =
  result = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"

proc preprocess(s: string): seq[int] =
  result = newSeq[int]()
  for i in s.split(" "):
    result.add(parseInt(i))

proc processItem(data: var seq[int]): int =
  let 
    children = data[0]
    metadata = len(data) - data[1]
    slice = data[metadata .. len(data)]
  result = sum(slice)

proc sampleRun() =
  var 
    data = sampleData()
    preprocessed = preprocess(data)
  assert len(preprocessed) == 16
  echo processItem(preprocessed)

when isMainModule:
  sampleRun()