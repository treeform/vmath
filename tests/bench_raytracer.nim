## Based on the work of https://github.com/edin/raytracer
## MIT License
## Copyright (c) 2021 Edin Omeragic

import benchy, chroma, math, pixie, vmath

{.push inline, noinit, checks: off.}

type
  SurfaceType = enum
    ShinySurface, CheckerBoardSurface

  ObjectType = enum
    Sphere, Plane

  Camera = object
    forward, right, up, pos: Vec3

  Ray = object
    start, dir: Vec3

  Thing = ref object
    surfaceType: SurfaceType
    case objectType: ObjectType
    of Sphere:
      center: Vec3
      radius2: float32
    of Plane:
      normal: Vec3
      offset: float32

  Intersection = object
    thing: Thing
    ray: Ray
    dist: float32

  Light = object
    pos: Vec3
    color: Color

  Scene = ref object
    maxDepth: int
    things: seq[Thing]
    lights: seq[Light]
    camera: Camera

  SurfaceProperties = object
    diffuse, specular: Color
    reflect, roughness: float32

const
  farAway: float32 = 1000000.0
  white = color(1.0, 1.0, 1.0)
  grey = color(0.5, 0.5, 0.5)
  black = color(0.0, 0.0, 0.0)
  background = color(0.0, 0.0, 0.0)
  defaultColor = color(0.0, 0.0, 0.0)

proc `*`(c: Color, k: float32): Color = color(k * c.r, k * c.g, k * c.b)
proc `*`(a: Color, b: Color): Color = color(a.r * b.r, a.g * b.g, a.b * b.b)
proc `+`(a: Color, b: Color): Color = color(a.r + b.r, a.g + b.g, a.b + b.b)

proc newCamera(pos: Vec3, lookAt: Vec3): Camera =
  var
    down = vec3(0.0, -1.0, 0.0)
    forward = lookAt - pos
  result.pos = pos
  result.forward = forward.normalize()
  result.right = result.forward.cross(down)
  result.up = result.forward.cross(result.right)
  let
    rightNorm = result.right.normalize()
    upNorm = result.up.normalize()
  result.right = rightNorm * 1.5
  result.up = upNorm * 1.5

proc getNormal(obj: Thing, pos: Vec3): Vec3 =
  case obj.objectType:
    of Sphere:
      return (pos - obj.center).normalize()
    of Plane:
      return obj.normal

proc objectIntersect(obj: Thing, ray: Ray): Intersection =
  case obj.objectType:
    of Sphere:
      let
        eo = obj.center - ray.start
        v = eo.dot(ray.dir)
      if v >= 0:
        var dist = 0.0
        let disc = obj.radius2 - (eo.dot(eo) - (v * v))
        if disc >= 0:
          dist = v - sqrt(disc)
        if dist != 0.0:
          result.thing = obj
          result.ray = ray
          result.dist = dist
    of Plane:
      let denom = obj.normal.dot(ray.dir)
      if denom <= 0:
        result.dist = (obj.normal.dot(ray.start) + obj.offset) / (-denom)
        result.thing = obj
        result.ray = ray

proc newSphere(center: Vec3, radius: float32, surfaceType: SurfaceType): Thing =
  Thing(surfaceType: surfaceType, objectType: Sphere, center: center,
    radius2: radius * radius)

proc newPlane(normal: Vec3, offset: float32, surfaceType: SurfaceType): Thing =
  Thing(surfaceType: surfaceType, objectType: Plane, normal: normal,
    offset: offset)

proc getSurfaceProperties(obj: Thing, pos: Vec3): SurfaceProperties =
  case obj.surfaceType:
    of ShinySurface:
      result.diffuse = white
      result.specular = grey
      result.reflect = 0.7
      result.roughness = 250.0
    of CheckerBoardSurface:
      let val = int(floor(pos.z) + floor(pos.x))
      if val mod 2 != 0:
        result.reflect = 0.1
        result.diffuse = white
      else:
        result.reflect = 0.7
        result.diffuse = black
      result.specular = white
      result.roughness = 150.0

proc newScene(): Scene =
  result = Scene()
  result.maxDepth = 5
  result.things = @[
    newPlane(vec3(0.0, 1.0, 0.0), 0.0, CheckerBoardSurface),
    newSphere(vec3(0.0, 1.0, -0.25), 1.0, ShinySurface),
    newSphere(vec3(-1.0, 0.5, 1.5), 0.5, ShinySurface)
  ]
  result.lights = @[
    Light(pos: vec3(-2.0, 2.5, 0.0), color: color(0.49, 0.07, 0.07)),
    Light(pos: vec3(1.5, 2.5, 1.5), color: color(0.07, 0.07, 0.49)),
    Light(pos: vec3(1.5, 2.5, -1.5), color: color(0.07, 0.49, 0.071)),
    Light(pos: vec3(0.0, 3.5, 0.0), color: color(0.21, 0.21, 0.35))
  ]
  result.camera = newCamera(vec3(3.0, 2.0, 4.0), vec3(-1.0, 0.5, 0.0))

proc intersections(scene: Scene, ray: Ray): Intersection =
  var closest: float32 = farAway
  result.thing = nil
  for thing in scene.things:
    let intersect = objectIntersect(thing, ray)
    if (not isNil(intersect.thing)) and (intersect.dist < closest):
      result = intersect
      closest = intersect.dist

proc testRay(scene: Scene, ray: Ray): float32 =
  let intersection = scene.intersections(ray)
  if not isNil(intersection.thing):
    return intersection.dist
  return NaN

proc shade(scene: Scene, intersection: Intersection, depth: int): Color

proc traceRay(scene: Scene, ray: Ray, depth: int): Color =
  let intersection = intersections(scene, ray)
  if not isNil(intersection.thing):
    return scene.shade(intersection, depth)
  return background

proc getReflectionColor(
  scene: Scene, thing: Thing, pos: Vec3, normal: Vec3, reflectDir: Vec3,
  depth: int
): Color =
  var
    ray: Ray = Ray(start: pos, dir: reflectDir)
    color = scene.traceRay(ray, depth + 1)
    properties = getSurfaceProperties(thing, pos)
  return color * properties.reflect

proc getNaturalColor(scene: Scene, thing: Thing, pos, norm,
  reflectDir: Vec3
): Color =
  result = black
  var
    reflectDirNorm = reflectDir.normalize()
    sp = getSurfaceProperties(thing, pos)
  for light in scene.lights:
    let
      lightDist = light.pos - pos
      lightVec = lightDist.normalize()
      lightDistLen = lightDist.length()
      ray = Ray(start: pos, dir: lightVec)
      neatIntersection = scene.testRay(ray)
      isInShadow = neatIntersection.classify != fcNan and
        neatIntersection <= lightDistLen

    if not isInShadow:
      let
        illumination = lightVec.dot(norm)
        specular = lightVec.dot(reflectDirNorm)
      var
        lightColor =
          if illumination > 0: light.color * illumination
          else: defaultColor
        specularColor =
          if specular > 0: light.color * pow(specular, sp.roughness)
          else: defaultColor
      lightColor = lightColor * sp.diffuse
      specularColor = specularColor * sp.specular
      result = result + lightColor + specularColor

proc shade(scene: Scene, intersection: Intersection, depth: int): Color =
  var
    dir = intersection.ray.dir
    scaled = dir * intersection.dist
    pos = scaled + intersection.ray.start
    normal = intersection.thing.getNormal(pos)
    reflectDir = dir - (normal * normal.dot(dir) * 2)
    naturalColor = background + getNaturalColor(scene, intersection.thing,
      pos, normal, reflectDir)
    reflectedColor: Color
  if depth >= scene.maxDepth:
    reflectedColor = grey
  else:
    reflectedColor = getReflectionColor(scene, intersection.thing, pos, normal,
      reflectDir, depth)
  return naturalColor + reflectedColor

proc getPoint(x, y: int, camera: Camera, screenWidth, screenHeight: int): Vec3 =
  var
    sw = float32(screenWidth)
    sh = float32(screenHeight)
    xf = float32(x)
    yf = float32(y)
    recenterX = (xf - (sw / 2.0)) / 2.0 / sw
    recenterY = -(yf - (sh / 2.0)) / 2.0 / sh
    vx = camera.right * recenterX
    vy = camera.up * recenterY
    v = vx + vy
    z = camera.forward + v
  return z.normalize()

proc renderScene(scene: Scene, sceneImage: Image) =
  var ray: Ray
  let
    h = sceneImage.height
    w = sceneImage.width
  ray.start = scene.camera.pos
  for y in 0 ..< h:
    var pos = y * w
    for x in 0 ..< w:
      ray.dir = getPoint(x, y, scene.camera, h, w)
      sceneImage.unsafe[x, y] = scene.traceRay(ray, 0).asRgbx()
      pos = pos + 1

proc render(): Image =
  var
    scene = newScene()
  result = newImage(500, 500)
  renderScene(scene, result)

render().writeFile("tests/raytracer.png")

timeIt "raytracer", 100:
  discard render()
