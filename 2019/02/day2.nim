import sugar
import arraymancer

proc setup(input: var Tensor, a: int = 12, b: int = 2) =
  input[1] = a
  input[2] = b

proc op(operator: (int, int) -> int, input: var Tensor[int], idx: var int) =
  let a = input[input[idx + 1]]
  let b = input[input[idx + 2]]
  input[input[idx + 3]] = a.operator(b)
  idx += 4

proc opAdd(input: var Tensor[int], idx: var int) =
  op((a, b) => (a + b), input, idx)

proc opMult(input: var Tensor[int], idx: var int) =
  op((a, b) => (a * b), input, idx)

proc handle(input: var Tensor[int]): Tensor[int] =
  var idx = 0
  while input[idx] != 99:
    case input[idx]
      of 1:
        input.opAdd(idx)
      of 2:
        input.opMult(idx)
      else:
        raise newException(ValueError, "illegal opcode")

  result = input

when isMainModule:
  var input = read_csv[int]("input.txt", skip_header=false)
  input = input.reshape(input.shape[1])
  let copied = input.clone

  setup(input)

  var a = @[1,0,0,0,99].toTensor
  assert handle(a) == @[2, 0, 0, 0, 99].toTensor

  echo "part 1"
  echo handle(input)[0]

  echo "part 2"
  for i in 0..99:
    for j in 0..99:
      input = copied.clone

      try:
        setup(input, i, j)
        let value = handle(input)
        if value[0] == 19690720:
          echo (100 * i) + j
      except:
        continue







