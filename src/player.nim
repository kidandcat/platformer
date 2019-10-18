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
  network,
  json,
  asyncDispatch,
  chan


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
  Player* = ref object of Entity
    name*: string
    level*: Level
    looking*: string
    animation*: string
    dying: bool
    won*: bool
    requestCoins*: seq[CoordInt]



proc updateVisibility*(player: Player) =
  # update the visible portion of the map
  let center = player.level.tileIndex(player.pos)
  player.level.show = (
    x: (center.x - VisibilityDim.w)..(center.x + VisibilityDim.w),
    y: (center.y - VisibilityDim.h)..(center.y + VisibilityDim.h))


proc resetPosition*(player: Player) =
  # reset player position to a given tile
  player.pos = player.level.tilePos player.level.firstTileIndex(Spawn)


proc init*(player: Player, graphic: TextureGraphic, level: Level) =
  player.initEntity()
  player.tags.add "player"
  player.level = level
  player.graphic = graphic
  player.initSprite((PlayerSize, PlayerSize), (PlayerSize * 9, 0))
  discard player.addAnimation("standLeft", [0], 1/12)
  discard player.addAnimation("standRight", [0], 1/12, Flip.horizontal)
  discard player.addAnimation("right", [0, 1, 2], 1/12, Flip.horizontal)
  discard player.addAnimation("left", [0, 1, 2], 1/12)
  discard player.addAnimation("jumpLeft", [3], 4/12)
  discard player.addAnimation("jumpRight", [3], 4/12, Flip.horizontal)

  # collider
  let c = newGroupCollider(player)
  player.collider = c
  # 1st collider
  c.list.add newCircleCollider(
    player,
    (PlayerRadius, PlayerRadius),
    ColliderRadius)
  # 2nd collider
  c.list.add newBoxCollider(
    player,
    (PlayerRadius, PlayerRadius + PlayerRadius div 2),
    (PlayerSize - 2, ColliderRadius))

  # physics
  player.acc.y = GravAcc
  player.drg.x = Drag
  player.physics = platformerPhysics


proc newPlayer*(name: string, graphic: TextureGraphic, level: Level): Player =
  new result
  result.name = name
  result.init(graphic, level)


proc jump*(player: Player) =
  if player.dying: return
  if player.vel.y == 0.0:
    player.vel.y -= JumpVel
    if player.looking == "left":
      player.play("jumpLeft", 1)
      player.animation = "jumpLeft"
    else:
      player.play("jumpRight", 1)
      player.animation = "jumpRight"
    discard sfxData["jump"].play()


proc right*(player: Player, elapsed: float) =
  if player.dying: return
  player.vel.x = MaxVel
  if not player.sprite.playing and player.vel.y == 0.0:
    player.play("right", 1)
    player.looking = "right"
    player.animation = "right"
  elif player.looking != "right":
    player.looking = "right"
    player.animation = "jumpRight"
    player.play("jumpRight", 1)


proc left*(player: Player, elapsed: float) =
  if player.dying: return
  player.vel.x = -MaxVel
  if not player.sprite.playing and player.vel.y == 0.0:
    player.play("left", 1)
    player.looking = "left"
    player.animation = "left"
  elif player.looking != "left":
    player.looking = "left"
    player.animation = "jumpLeft"
    player.play("jumpLeft", 1)


var lastData : JsonNode
var delta = 0.0
method update*(player: Player, elapsed: float) =
  player.updateEntity elapsed
  player.updateVisibility()

  if player.vel.y == 0 and (player.animation == "jumpLeft" or player.animation == "jumpRight"):
    if player.looking == "left":
      player.animation = "standLeft"
      player.play("standLeft", 1)
    else:
      player.animation = "standRight"
      player.play("standRight", 1)

  delta += elapsed
  if delta > 0.1:
    delta = 0.0
    var d = %*{
      "name": player.name,
      "x": int(player.pos.x),
      "y": int(player.pos.y),
      "looking": player.looking,
      "playing": player.sprite.playing,
      "animation": player.animation
    }
    if d != lastData:
      lastData = d
      toNetwork.send $d

method onCollide*(player: Player, target: Entity) =
  if "finish" in target.tags:
    if not player.won:
      discard sfxData["victory"].play()
    player.won = true

