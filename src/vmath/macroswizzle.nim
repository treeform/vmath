
{.experimental: "dotOperators".}
proc num(letter: char, fields: NimNode): int =
  ## Given a swizzle character gives back the location number.
  case letter:
  of 'x', 'r', 's': 0
  of 'y', 'g', 't': 1
  of 'z', 'b', 'p': 2
  of 'w', 'a', 'q': 3
  else:
    error "invalid swizzle character: " & letter, fields
    quit()

proc typePrefix(node: NimNode): string =
  ## Given a node of type GVec234 gives its prefix type.
  ## IVec2 -> "i", DVec4 -> "d", Vec3 -> ""
  let typeName =
    when defined(vmathArrayBased):
      node.getType()[2].repr
    elif defined(vmathObjBased):
      node.getType()[2][0].getType().repr
    elif true or defined(vmathObjArrayBased):
      node.getType()[2][0].getType()[2].repr
  case typeName:
  of "bool": "b"
  of "int32": "i"
  of "uint32": "u"
  of "float32": ""
  of "float", "float64": "d"
  else:
    error "invalid vector type: " & typeName, node
    quit()

macro `.`*(v: GVec234, fields: untyped): untyped =
  ## Adds support for swizzle getter.
  ##  x y z w
  ##  r g b a
  ##  s t p q
  ## v.xyz, v.xxx, v.zyx ...
  ## v.rgb, v.rrr, v.bgr ...
  ## v.stp, v.sss, v.pts ...
  let swizzle = fields.repr
  let vec = ident(typePrefix(v) & "vec" & $swizzle.len)
  if swizzle.len == 1:
    let a = num(swizzle[0], fields)
    result = quote do:
      `v`[`a`]
  elif swizzle.len == 2:
    let
      a = num(swizzle[0], fields)
      b = num(swizzle[1], fields)
    result = quote do:
      `vec`(`v`[`a`], `v`[`b`])
  elif swizzle.len == 3:
    let
      a = num(swizzle[0], fields)
      b = num(swizzle[1], fields)
      c = num(swizzle[2], fields)
    result = quote do:
      `vec`(`v`[`a`], `v`[`b`], `v`[`c`])
  elif swizzle.len == 4:
    let
      a = num(swizzle[0], fields)
      b = num(swizzle[1], fields)
      c = num(swizzle[2], fields)
      d = num(swizzle[3], fields)
    result = quote do:
      `vec`(`v`[`a`], `v`[`b`], `v`[`c`], `v`[`d`])
  else:
    error "invalid number of swizzle characters: " & swizzle, fields

macro `.=`*(v: GVec234, fields: untyped, e: untyped): untyped =
  ## Adds support for swizzle setter.
  ##  x y z w
  ##  r g b a
  ##  s t p q
  ## v.xyz, v.xxx, v.zyx ...
  ## v.rgb, v.rrr, v.bgr ...
  ## v.stp, v.sss, v.pts ...
  let swizzle = fields.repr
  if swizzle.len == 1:
    let a = num(swizzle[0], fields)
    result = quote do:
      `v`[`a`] = `e`
  elif swizzle.len == 2:
    let
      a = num(swizzle[0], fields)
      b = num(swizzle[1], fields)
    result = quote do:
      block:
        let tmp = `e`
        `v`[`a`] = tmp[0]
        `v`[`b`] = tmp[1]
  elif swizzle.len == 3:
    let
      a = num(swizzle[0], fields)
      b = num(swizzle[1], fields)
      c = num(swizzle[2], fields)
    result = quote do:
      block:
        let tmp = `e`
        `v`[`a`] = tmp[0]
        `v`[`b`] = tmp[1]
        `v`[`c`] = tmp[2]
  elif swizzle.len == 4:
    let
      a = num(swizzle[0], fields)
      b = num(swizzle[1], fields)
      c = num(swizzle[2], fields)
      d = num(swizzle[3], fields)
    result = quote do:
      block:
        let tmp = `e`
        `v`[`a`] = tmp[0]
        `v`[`b`] = tmp[1]
        `v`[`c`] = tmp[2]
        `v`[`d`] = tmp[3]
  else:
    error "invalid number of swizzle characters: " & swizzle, fields
