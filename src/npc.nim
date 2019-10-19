import
  nimgame2 / [
    assets,
    audio,
    entity,
    texturegraphic,
    tilemap,
    types,
  ],
  data,
  json,
  player


const
  PlayerRadius = 8
  PlayerSize = PlayerRadius * 2


type
  Npc* = ref object of Entity
    name*: string

proc init*(npc: Npc) =
  npc.initEntity()
  npc.tags.add "npc"
  npc.graphic = gfxData["arcade"]
  npc.initSprite((PlayerSize, PlayerSize), (PlayerSize * 9, 0))
  discard npc.addAnimation("standLeft", [0], 1/12)
  discard npc.addAnimation("standRight", [0], 1/12, Flip.horizontal)
  discard npc.addAnimation("right", [0, 1, 2], 1/12, Flip.horizontal)
  discard npc.addAnimation("left", [0, 1, 2], 1/12)
  discard npc.addAnimation("jumpLeft", [3], 4/12)
  discard npc.addAnimation("jumpRight", [3], 4/12, Flip.horizontal)
  npc.physics = platformerPhysics
  # collider
  let c = newGroupCollider(npc)
  npc.collider = c
  # 1st collider
  c.list.add newCircleCollider(
    npc,
    (PlayerRadius, PlayerRadius),
    ColliderRadius)

proc updatePos*(npc: Npc, pos: JsonNode) =
  var oldPos = (npc.pos.x, npc.pos.y)
  var newPos =(pos["x"].getFloat, pos["y"].getFloat)

  var dir = newPos - oldPos
  # var modulo = sqrt(dir[0]^2 + dir[1]^2)
  # var normDir = dir / modulo

  npc.vel.x = dir[0] * 10
  npc.vel.y = dir[1] * 10
 
  echo dir[0], dir[1]

  if pos["playing"].getBool:
    npc.play(pos["animation"].getStr, 1)


method update*(npc: Npc, elapsed: float) =
  npc.updateEntity elapsed
