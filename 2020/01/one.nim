import strutils

let
  lines = readFile("input").string.splitLines()

# Wow, so I took the laziest possible approach here.
# Brute force! It would likely be faster another way.

# part one
block one:
  for i, a in lines.pairs:
    for j, b in lines.pairs:
      if i == j:
        continue

      try:
        let x = a.parseInt
        let y = b.parseInt
        if x + y == 2020:
          echo x * y
          break one
      except:
        continue

# part two
block two:
  for i, a in lines.pairs:
    for j, b in lines.pairs:
      for k, c in lines.pairs:
        if i == j or i == k or j == k:
          continue

        try:
          let x = a.parseInt
          let y = b.parseInt
          let z = c.parseInt
          if x + y + z == 2020:
            echo x * y * z
            break two
        except:
          continue


