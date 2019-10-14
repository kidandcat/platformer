import
  parseutils,
  sequtils,
  nimgame2 / [
    assets,
    entity,
    texturegraphic,
    tilemap,
    types,
    utils,
  ],
  data


const
  TileDim* = (16, 16)
  Hidden = @[93] # tiles on the third row are invisible markers
  EmptyTile = 406
  Passable = @[EmptyTile, 82, 93] # tiles without colliders


type
  Level* = ref object of TileMap


proc init*(level: Level, tiles: TextureGraphic) =
  init Tilemap level
  level.tags.add "level"
  level.graphic = tiles
  level.initSprite(TileDim)


proc newLevel*(tiles: TextureGraphic, layer: int): Level =
  var level = new Level
  level.init(tiles)
  level.map = loadCSV[int](
    "data/csv/map1_collision.csv",
    proc(input: string): int = 
      discard parseInt(input, result)
      if result < 0:
        result = EmptyTile
  )
  level.hidden.add Hidden  
  level.passable.add Passable 
  level.onlyReachableColliders = true # do not init unreachable colliders
  level.initCollider()
  level.collider.tags.add "nil" # do not check for collisions
  level.layer = layer
  return level


proc newMiscLevel*(tiles: TextureGraphic, name: string, layer: int): Level =
  var level = new Level
  level.init(tiles)
  level.map = loadCSV[int](
    "data/csv/map1_"&name&".csv",
    proc(input: string): int = 
      discard parseInt(input, result)
      if result < 0:
        result = EmptyTile
  )
  level.layer = layer
  return level