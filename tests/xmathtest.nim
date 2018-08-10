# nim c -r --verbosity:0 test\xmathtest > test\xmathtest.test.txt; tools\dos2unix test\xmathtest.test.txt; git diff test\xmathtest.test.txt

include xmath


randomize(1234)


block:
  echo "--- basic vector xvec2"
  var a = xvec2(1, 2)
  var b = xvec2(7, 6)
  var n = 13.7
  echo a + b
  echo a - b
  echo a * n
  echo a / n
  a += b
  echo a
  a -= b
  echo a
  a *= n
  echo a
  a /= n
  echo a

block:
  echo "--- basic vector xvec3"
  var a = xvec3(1, 2, 3)
  var b = xvec3(7, 6, 5)
  var n = 13.7
  echo a + b
  echo a - b
  echo a * n
  echo a / n
  a += b
  echo a
  a -= b
  echo a
  a *= n
  echo a
  a /= n
  echo a

block:
  echo "--- basic vector xvec4"
  var a = xvec4(1, 2, 3, 4)
  var b = xvec4(7, 6, 5, 4)
  var n = 13.7
  echo a + b
  echo a - b
  echo a * n
  echo a / n
  a += b
  echo a
  a -= b
  echo a
  a *= n
  echo a
  a /= n
  echo a
