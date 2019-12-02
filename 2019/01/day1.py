#!/usr/bin/env python
import math


def compute(x: int) -> int:
    return math.floor((x / 3.0)) - 2


def compute_with_fuel(x: int) -> int:
    remainder = compute(x)
    fuels = [remainder]
    while remainder >= 0:
        remainder = compute(remainder)
        if remainder >= 0:
            fuels.append(remainder)

    return sum(fuels)


if __name__ == '__main__':
    with open('input.txt', 'r') as fp:
        raw_modules = fp.readlines()

    modules = [int(x) for x in raw_modules if len(x) > 0]

    print("part 1")
    print(sum([compute(x) for x in modules]))

    print("part 2")
    print(sum([compute_with_fuel(x) for x in modules]))
