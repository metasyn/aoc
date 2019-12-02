import arraymancer, sugar

func compute(x: Tensor[float]): int =
  result = sum((x ./ 3.0).map(x => floor(x)) .- 2).int

proc compute_with_fuel(x: Tensor[float]): int =
  var fuel = compute(x)
  var fuels = @[fuel]
  while fuel > 0:
    fuel = compute(@[fuel.float].toTensor)
    if fuel >= 0:
      fuels.add(fuel)
  result = fuels.toTensor.sum.int

when isMainModule:
  let modules = read_csv[float]("input.txt", skip_header=false, separator='\c').transpose
  echo "part 1"
  echo compute(modules)

  echo "part 2"
  echo sum(modules.map(x => compute_with_fuel(@[x].toTensor)))
