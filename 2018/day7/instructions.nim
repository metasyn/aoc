import tables, strutils, sequtils, algorithm, sets, random, strformat
import ../util

type DepGraph = TableRef[char, seq[char]]
type Nodes = HashSet[char]

proc extract(line: string): tuple[a, b: char] =
  let a = line[5]
  let b = line[36]
  assert a.isUpperAscii()
  assert b.isUpperAscii()
  return (a, b)

proc makeDependencies(data: seq[string]): tuple[nodes: HashSet[char], deps: DepGraph] =
  var 
    deps = newTable[char, seq[char]]()
    nodes = initSet[char]()

  for line in data:
    let (dep, item) = line.extract()
    nodes.incl(dep)
    nodes.incl(item)
    discard deps.hasKeyOrPut(item, newSeq[char]())
    discard deps.hasKeyOrPut(dep, newSeq[char]())
    let chars = deps[item]
    if not chars.contains(dep):
      deps[item].add(dep)
  

  return (nodes, deps)

proc process(data: seq[string]): string =
  let (nodes, deps) = makeDependencies(data)
  result = ""

  for _ in 0 ..< len(nodes):
    var ready = newSeq[char]()

    block check:
      for k, v in deps:
        if len(v) == 0:
          ready.add(k)
          deps.del(k)
          break check
    
    ready = sorted(ready, system.cmp)
    let c = ready[0]
    result.add(c)
    for k, v in deps.mpairs:
      let idx = v.find(c)
      if idx > -1:
        v.delete(idx)
        

proc letterToWait(c: char, base: int = 60): int =
  let a = c.toLowerAscii()
  var i = 1
  for x in 'a'..'z':
    if x == a:
      return i + base
    i += 1

type
  Worker = ref object
    id: int
    working: bool
    task: char
    time: int

proc newWorker(c: char, wait: int): Worker =
  result = Worker(
    id: rand(500),
    working: true,
    task: c,
    time: letterToWait(c, wait),
  )

proc `$`(w: Worker): string =
  result = fmt"w: {w.id} {w.working} {w.task} {w.time}"

proc finish(w: Worker) =
  w.working = false

proc tick(w: Worker) =
  w.time -= 1

proc tick(workers: seq[Worker]) =
  for w in workers:
    if not isNil(w):
      if w.working:
        w.tick()

proc report(workers: var seq[Worker]): seq[char] =
  for i, w in workers:
    if not isNil(w):
      if w.time == 0:
        # Reset
        w.finish()
        result.add(w.task)
  result = sorted(result, system.cmp)

proc multi(data: seq[string], nWorkers: int, wait: int = 60): tuple[a: string, b: int] =
  let (nodes, deps) = makeDependencies(data)
  var
    workers = newSeq[Worker](nWorkers)
    steps = ""
    elapsed: int


  while len(steps) < len(nodes):
    # Get whatever finished on the last round
    let done = workers.report()
    if len(done) > 0:
      for i, c in done:
        if not steps.contains(c):
          steps.add(c)
        for k, v in deps.mpairs:
          let idx = v.find(c)
          if idx > -1:
            v.delete(idx)
    
    # Check for ready tasks
    var ready = newSeq[char]()
    for k, v in deps:
      if len(v) == 0:
        ready.add(k)
    
    ready = sorted(ready, system.cmp)

    # Assign as many tasks as possible
    for i, c in ready:
      block assignment:
        for j, w in workers:
          if isNil(w):
            workers[j] = newWorker(c, wait)
            deps.del(c)
            break assignment
          elif not w.working:
            workers[j] = newWorker(c, wait)
            deps.del(c)
            break assignment

    workers.tick()
    elapsed += 1
  return (steps, elapsed - 1)

proc sampleRun() =
  let data = getSample(7)
  assert extract(data[0]) == ('A', 'B')
  assert process(data) == "CABDFE"
  let (answer, time) = multi(data, nWorkers = 2, wait = 0)
  assert time == 15

when isMainModule:
  sampleRun()
  let data = getInput(7)
  let answer = process(data)
  echo "part 1: ", answer
  let (answer2, time) = multi(data, nWorkers = 5, wait = 60)
  assert len(answer) == len(answer2)
  echo "part 2: ", time

