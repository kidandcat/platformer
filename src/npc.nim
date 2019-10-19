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
  json


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

proc updatePos*(npc: Npc, pos: JsonNode) =
  echo "update pos " & npc.name
  npc.pos.x = pos["x"].getFloat
  npc.pos.y = pos["y"].getFloat
  if pos["playing"].getBool:
    npc.play(pos["animation"].getStr, 1)


method update*(npc: Npc, elapsed: float) =
  npc.updateEntity elapsed
