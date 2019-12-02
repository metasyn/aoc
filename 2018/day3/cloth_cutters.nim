import streams, re, strutils, strformat

type
    Row[N: static[int]] = array[N, int]
    Matrix[M, N: static[int]] = array[M, Row[N]]

let claim = re"#\d+\s@\s(\d+),(\d+):\s(\d+)x(\d+)"

func makeMatrix(M, N: static int): Matrix[M, N] =
    # Initialize Row
    var r: Row[N]
    # Initialize Matrix
    var m:  Matrix[M, N]
    result = m

proc readClaims(): seq[string] =
    var line = ""
    result = newSeq[string]()

    let fs = newFileStream("./day3/input.txt", fmRead)
    if not isNil(fs):
        while fs.readLine(line):
            result.add(line)
    
iterator claimProcessor(m: var Matrix, line: string): tuple[a, b: int] =
    var matches: array[4, string]
    var numbers: array[4, int]
    if match(line, claim, matches):
        # Left side + one to start
        for i in 0..3:
            numbers[i] = parseInt(matches[i])
        let
            column_start = numbers[0] + 1
            column_end = min(column_start + numbers[2], 1000)
            row_start = numbers[1] + 1
            row_end = min(row_start + numbers[3], 1000)
        
        for i in row_start..<row_end:
            for j in column_start..<column_end:
                yield (i, j)
    
    else:
        echo matches
        raise newException(ValueError, "Must match 4 values.")


when isMainModule:
    var m = makeMatrix(1000, 1000)
    let 
        claims = readClaims()
        max = len(claims)
    for idx, claim in claims:
        for i, j in claimProcessor(m, claim):
            m[i][j] += 1
        if idx %% 100 == 0:
            echo int((idx/max)*100), "%"

    var count: int
    for i in 0..<1000:
        for j in 0..<1000:
            if m[i][j] >= 2:
                count += 1

    echo "Part 1: ", count

    var answer: int = -1
    block search:
        for idx, claim in claims:
            block processor:
                for i, j in claimProcessor(m, claim):
                    if m[i][j] > 1: 
                        break processor 
                echo fmt"Part 2: Found {claim}"
                break search