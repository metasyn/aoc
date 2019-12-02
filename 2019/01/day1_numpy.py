#!/usr/bin/env python
import numpy as np


def compute(x: np.ndarray) -> int:
    return int(np.sum(np.floor((x / 3)) - 2))


def compute_with_fuel(x: np.ndarray) -> int:
    fuel = compute(x)
    values = [fuel]
    while fuel > 0:
        fuel = compute(fuel)
        if fuel > 0:
            values.append(fuel)
    return np.sum(values)


if __name__ == '__main__':
    modules = np.loadtxt('./input.txt', delimiter='\n')
    print("part 1")
    fuel = compute(modules)
    print(fuel)

    print("part 2")
    vfunc = np.vectorize(compute_with_fuel)
    print(np.sum(vfunc(modules)))
