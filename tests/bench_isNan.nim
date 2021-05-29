import benchy, vmath

proc isNaNSlow(f: SomeFloat): bool =
  ## Returns true if number is a NaN.
  f.classify notin {fcNormal, fcZero, fcSubnormal}

proc isNaNRyan(x: SomeFloat): bool =
  if x == 0.0:
    return false
  x != x or x * 0.5 == x

proc isNaN3*(x: SomeFloat): bool =
  ## Returns true if number is a NaN.
  x != 0.0 and (x != x or x * 0.5 == x)

assert isNaNSlow(0.3) == false
assert isNaNSlow(0.0) == false
assert isNaNSlow(0.3/0.0) == true
assert isNaNSlow(-0.3/0.0) == true
assert isNaNSlow(5.0e-324) == false

assert isNaNRyan(0.3) == false
assert isNaNRyan(0.0) == false
assert isNaNRyan(0.3/0.0) == true
assert isNaNRyan(-0.3/0.0) == true
assert isNaNRyan(5.0e-324) == false

assert isNan(float32(0.3)) == false
assert isNan(float32(0.0)) == false
assert isNan(float32(0.3/0.0)) == true
assert isNan(float32(-0.3/0.0)) == true
assert isNan(float32(5.0e-324)) == false

assert isNan(float64(0.3)) == false
assert isNan(float64(0.0)) == false
assert isNan(float64(0.3/0.0)) == true
assert isNan(float64(-0.3/0.0)) == true
assert isNan(float64(5.0e-324)) == false

assert isNan3(float32(0.3)) == false
assert isNan3(float32(0.0)) == false
assert isNan3(float32(0.3/0.0)) == true
assert isNan3(float32(-0.3/0.0)) == true
assert isNan3(float32(5.0e-324)) == false

assert isNan3(float64(0.3)) == false
assert isNan3(float64(0.0)) == false
assert isNan3(float64(0.3/0.0)) == true
assert isNan3(float64(-0.3/0.0)) == true
assert isNan3(float64(5.0e-324)) == false

const num = 1_00_000

timeIt "isNaNSlow float32":
  var x: float32
  var n = 0
  for i in 0 .. num:
    if x.isNaNSlow:
      n += 1
    x = float32(i) / float32(i)
  keep n

timeIt "isNaNSlow float64":
  var x: float64
  var n = 0
  for i in 0 .. num:
    if x.isNaNSlow:
      n += 1
    x = float64(i) / float64(i)
  keep n

timeIt "isNaNRyan float32":
  var x: float32
  var n = 0
  for i in 0 .. num:
    if x.isNaNRyan:
      n += 1
    x = float32(i) / float32(i)
  keep n

timeIt "isNaNRyan float64":
  var x: float64
  var n = 0
  for i in 0 .. num:
    if x.isNaNRyan:
      n += 1
    x = float64(i) / float64(i)
  keep n

timeIt "isNan float32":
  var x: float32
  var n = 0
  for i in 0 .. num:
    if x.isNan:
      n += 1
    x = float32(i) / float32(i)
  keep n

timeIt "isNan float64":
  var x: float64
  var n = 0
  for i in 0 .. num:
    if x.isNan:
      n += 1
    x = float64(i) / float64(i)
  keep n

timeIt "isNan3 float32":
  var x: float32
  var n = 0
  for i in 0 .. num:
    if x.isNan3:
      n += 1
    x = float32(i) / float32(i)
  keep n

timeIt "isNan3 float64":
  var x: float64
  var n = 0
  for i in 0 .. num:
    if x.isNan3:
      n += 1
    x = float64(i) / float64(i)
  keep n
