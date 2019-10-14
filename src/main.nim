import
  nimgame2 / [
    assets,
    entity,
    font,
    graphic,
    gui/button,
    gui/widget,
    input,
    nimgame,
    scene,
    settings,
    textgraphic,
    tilemap,
    types,
  ],
  data,
  enemy,
  level,
  player


const
  
  PlayerLayer = 10
  UILayer = 20
  Spikes = 4  # Spikes tile index
  CoinA = 2   # Coin tile index (frame A)
  CoinB = 3   # Coin tile index (frame B)
  EnemySpawn = 9  # Enemy spawn tile index
  Finish = 11     # Finish tile index


type
  MainScene* = ref object of Scene
    level: Level
    bg: Level
    player: Player
    score: TextGraphic
    victory: Entity


proc spawnCoin*(scene: MainScene, index: CoordInt) =
  let e = newEntity()
  e.tags.add "coin"
  e.graphic = gfxData["tiles"]
  e.initSprite(TileDim)
  discard e.addAnimation("rotate", [2, 3], 1/8)
  e.play("rotate", -1) # continuous animation
  e.pos = scene.level.tilePos index
  e.collider = newCircleCollider(e, TileDim / 2 - 1, TileDim[0] / 2 - 1)
  e.collider.tags.add "player"
  e.parent = scene.camera
  scene.add e


proc init*(scene: MainScene) =
  init Scene scene

  # Camera
  scene.camera = newEntity()
  scene.camera.tags.add "camera"
  scene.cameraBondOffset = game.size / 2  # set camera to the center

  # Level Background
  scene.level = newLevel(gfxData["arcade"], 1)
  scene.level.parent = scene.camera
  scene.add scene.level

  scene.bg = newMiscLevel(gfxData["arcade"], "bg", 0)
  scene.bg.parent = scene.camera
  scene.add scene.bg
  scene.bg = newMiscLevel(gfxData["arcade"], "back", 2)
  scene.bg.parent = scene.camera
  scene.add scene.bg
  scene.bg = newMiscLevel(gfxData["arcade"], "front", 11) # Player is 10
  scene.bg.parent = scene.camera
  scene.add scene.bg

  # bridge
  for tileCoord in scene.level.tileIndex(82):
    let e = newEntity()
    e.tags.add "bridge"
    e.pos = scene.level.tilePos(tileCoord)
    e.collider = newLineCollider(e, (0, TileDim[1]), (TileDim[0], TileDim[1]))
    e.collider.tags.add "player" # collide only with player entity
    e.parent = scene.camera
    scene.add e

  # Enemy
  # for tileCoord in scene.level.tileIndex(EnemySpawn):
  #   let e = newEnemy(gfxData["enemy"], scene.level)
  #   e.collisionEnvironment = @[Entity(scene.level)]
  #   e.pos = scene.level.tilePos(tileCoord) + TileDim[1] / 2
  #   e.parent = scene.camera
  #   scene.add e

  # Score
  let score = newEntity()
  scene.score = newTextGraphic defaultFont
  scene.score.setText "SCORE: 0"
  score.graphic = scene.score
  score.layer = UILayer
  score.pos = (12, 8)
  scene.add score

  # Victory
  let victoryText = newTextGraphic bigFont
  victoryText.setText "VICTORY!"
  scene.victory = newEntity()
  scene.victory.graphic = victoryText
  scene.victory.centrify(ver = VAlign.top)
  scene.victory.visible = false
  scene.victory.layer = UILayer
  scene.victory.pos = (GameWidth / 2, 0.0)
  scene.add scene.victory

  # Player
  scene.player = newPlayer(gfxData["arcade"], scene.level)
  scene.player.collisionEnvironment = @[Entity(scene.level)]
  scene.player.layer = PlayerLayer
  scene.player.resetPosition()
  scene.player.parent = scene.camera
  scene.add scene.player

  scene.cameraBond = scene.player # bind camera to the player entity
  scene.player.updateVisibility()


proc free*(scene: MainScene) =
  discard


proc newMainScene*(): MainScene =
  new result, free


method show*(scene: MainScene) =
  hideCursor()
  init scene


method event*(scene: MainScene, event: Event) =
  scene.eventScene event
  if event.kind == KeyDown:
    case event.key.keysym.sym:
    of K_F10:
      colliderOutline = not colliderOutline
    of K_F11:
      showInfo = not showInfo
    of K_Escape:
      game.scene = titleScene
    else: discard


method update*(scene: MainScene, elapsed: float) =
  scene.updateScene elapsed
  if ScancodeUp.pressed:
    scene.player.jump()
  if ScancodeRight.down:
    scene.player.right(elapsed)
  if ScancodeLeft.down:
    scene.player.left(elapsed)

  # Update score
  #  scene.score.setText "SCORE: " & $score

  # Check for victory
  # if scene.player.won:
  #   scene.victory.visible = true
