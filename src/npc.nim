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
  level,
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
  npc.initSprite((PlayerSize, PlayerSize), (PlayerSize * 6, 0))
  discard npc.addAnimation("right", [0, 1, 2], 1/12, Flip.horizontal)
  discard npc.addAnimation("left", [0, 1, 2], 1/12)
  discard npc.addAnimation("death", [2], 1/12)

proc updatePos*(npc: Npc, pos: JsonNode) =
  echo "update pos " & npc.name
  npc.pos.x = pos["x"].getFloat
  npc.pos.y = pos["y"].getFloat

method update*(npc: Npc, elapsed: float) =
  npc.updateEntity elapsed
