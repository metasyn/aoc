import arraymancer

proc at(a: Tensor[int], i: int, v: int): Tensor[int] =
  a[0, i] = v
  return a

proc setup(input: Tensor): Tensor[int] =
  result = input.at(0, 12)

proc opAdd(input: Tensor[int]): Tensor[int] =
  discard



when isMainModule:
  var input = read_csv[int]("input.txt", skip_header=false)
  echo input
  input = setup(input)
  echo input[0, 2]
  echo input


