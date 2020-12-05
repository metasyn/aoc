import re
import strutils
import parseutils

type Passport = object
  # ids
  pid: string
  cid: string
  # dates
  byr: int
  iyr: int
  eyr: int
  # appearance
  hgt: string
  hcl: string
  ecl: string
  fields: int
  invalid: bool

proc `$`*(passport: Passport): string =
  echo passport.byr
  echo passport.iyr

func advance(i: int, item: string): int =
  result = i + 4 + item.len + 1

proc extract(idx: var int, line: string): string =
  let item = line.captureBetween(':', ' ', start = idx).strip
  idx = idx.advance(item)
  return item

proc safeParse(str: string): int =
  try:
    result = parseInt(str)
  except:
    result = 0

# Quite wild; i can pass both the field name and the field value
# as a single untyped parameter here! kinda scary but nice
template assign(p: Passport, a: typed, b: bool) =
  if b:
    p.a = a
  else:
    p.invalid = true


proc parse(input: string): Passport =
  let line = input.replace("\n", " ")
  var idx: int = 0

  var passport: Passport

  while idx < line.len:
    let char = line[idx]
    case char:
      of 'b':
        let str = extract(idx, line)
        let byr = str.safeParse
        passport.assign(byr, byr >= 1920 and byr <= 2002 and str.len == 4)

      of 'i':
        let str = extract(idx, line)
        let iyr = str.safeParse
        passport.assign(iyr, iyr >= 2010 and iyr <= 2020 and str.len == 4)

      of 'e':
        if line[idx + 1] == 'y':
          let str = extract(idx, line)
          let eyr = str.safeParse
          passport.assign(eyr, eyr >= 2020 and eyr <= 2030 and str.len == 4)

        else:
          let ecl = extract(idx, line)
          passport.assign(ecl, @["amb", "blu", "brn", "gry", "grn", "hzl",
              "oth"].contains(ecl))

      of 'h':
        if line[idx + 1] == 'g':

          let hgt = extract(idx, line)
          let ending = hgt[^2 ..< hgt.len]
          let value = hgt[0 ..< ^2].safeParse

          var upper: int
          var lower: int

          if @["in", "cm"].contains(ending):
            if ending == "in":
              upper = 76
              lower = 59
            else:
              upper = 193
              lower = 150

            passport.assign(hgt, value >= lower and value <= upper)
          else:
            passport.invalid = true

        else:
          let hcl = extract(idx, line)
          passport.assign(hcl, hcl.match(re"^#[0-9a-f]{6}$"))

      of 'p':
        let pid = extract(idx, line)
        passport.assign(pid, pid.match(re"^\d{9}$"))

      of 'c':
        passport.cid = extract(idx, line)
        # Don't update fields for meaningless cid field
        continue

      else:
        idx += 1
        continue

    passport.fields += 1

  return passport

let lines = readFile("input").string.split("\n\n")
var validOne: int
var validTwo: int

for line in lines:
  let passport = parse(line)

  if passport.fields >= 7:
    validOne += 1

    if not passport.invalid:
      validtwo += 1

echo "one"
echo validOne

echo "two"
echo validTwo

