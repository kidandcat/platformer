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
  level


const
  VisibilityDim: Dim = (w: 24, h: 15)
  Spawn = 93 # player spawn selector tile index
  PlayerRadius = 8
  PlayerSize = PlayerRadius * 2
  ColliderRadius = PlayerRadius - 1
  GravAcc = 800
  Drag = 2000
  JumpVel = 250
  MaxVel = 150


type
  Npc* = ref object of Entity
    name*: string



proc init*(player: Npc) =
  player.initEntity()
  player.tags.add "npc"
  player.graphic = gfxData["arcade"]
  player.initSprite((PlayerSize, PlayerSize), (PlayerSize * 6, 0))
  discard player.addAnimation("right", [0, 1, 2], 1/12, Flip.horizontal)
  discard player.addAnimation("left", [0, 1, 2], 1/12)
  discard player.addAnimation("death", [2], 1/12)


method update*(player: Npc, elapsed: float) =
  player.updateEntity elapsed
