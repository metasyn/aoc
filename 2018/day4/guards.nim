import streams, times, strutils, sequtils, tables, algorithm, re
import ../util

type
  Guard = object
    id: int
    slept: int64
    mins: CountTableRef[range[0..59]]

proc processDate(line: string): DateTime =
  return parse(line[1..16], "yyyy-MM-dd HH:mm", utc())

proc minuteDelta(t1, t2: DateTime): int64 =
  let delta = t1 - t2
  result = delta.minutes

# Initial guard
proc processGuards(lines: seq[string]): Table[int, Guard] =
  result = initTable[int, Guard]()
  var 
    id: int 
    guard = Guard()
    asleep: bool
    startSleep = now()
    endSleep = now() 

  for line in lines:

    var matches: array[1, string]
    if match(line, re".*Guard #(\d+)", matches):
      # Save previous guard we were working on
      result[id] = guard

      # Get new id
      id = parseInt(matches[0])

      # Fetch if we've seen this fellow before
      if result.hasKey(id):
        guard = result[id]

      # Make a new one otherwise
      else:
        guard = Guard()
        guard.id = id
        guard.mins = newCountTable[range[0..59]]()

    # Record falling asleep
    elif line.contains("falls"):
      startSleep = line.processDate()

    # Record waking, and update guard object
    elif line.contains("wakes"):
      endSleep = line.processDate()
      let 
        delta = minuteDelta(endSleep, startSleep)
        startMin = startSleep.minute
        endMin = startMin + delta

      guard.slept += delta
      
      for i in startMin.int ..< startMin.int + delta:
        let modulo = (i %% 60).int
        guard.mins.inc(modulo)

proc getSleepyGuard(guards: Table[int, Guard]): Guard =
  var 
    max: int
    id: int

  for key, guard in guards:
    if guard.slept > max:
      max = guard.slept.int
      id = key

  result = guards[id]

proc getMagicNumber(guard: Guard): int =
  result = guard.id * guard.mins.largest()[0]

proc part2(guards: Table[int, Guard]): int =
  var 
    max: int
    id: int

  for key, guard in guards:
    if not isNil(guard.mins) and len(guard.mins) > 0:
      let tupe = guard.mins.largest()
      if tupe[1] > max:
        max = tupe[1]
        id = key
  
  let guard = guards[id]
  result = guard.mins.largest()[0] * guard.id
  
when isMainModule:
  let 
    lines = getInput(4)
    guards = processGuards(lines)
    sleepy = getSleepyGuard(guards)
    answer = getMagicNumber(sleepy)

  echo "part 1: ", answer
  echo "part 2: ", part2(guards)


  