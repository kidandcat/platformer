import
  nimgame2 / [
    assets,
    audio,
    font,
    mosaic,
    scene,
    texturegraphic,
    truetypefont,
    types,
  ]


const
  GameWidth* = 640
  GameHeight* = 360
  GameTitle* = "Platformer"


var
  titleScene*, mainScene*: Scene
  defaultFont*, bigFont*: TrueTypeFont
  gfxData*: Assets[TextureGraphic]
  sfxData*: Assets[Sound]
  buttonMosaic*: Mosaic
  buttonSkin*: TextureGraphic
  inputMosaic*: Mosaic
  inputSkin*: TextureGraphic
  score*: int


proc loadData*() =
  defaultFont = newTrueTypeFont()
  if not defaultFont.load("data/fnt/FSEX300.ttf", 16):
    echo "ERROR: Can't load font"
  bigFont = newTrueTypeFont()
  if not bigFont.load("data/fnt/FSEX300.ttf", 32):
    echo "ERROR: Can't load font"

  gfxData = newAssets[TextureGraphic](
    "data/gfx",
    proc(file: string): TextureGraphic = newTextureGraphic(file))

  sfxData = newAssets[Sound](
    "data/sfx",
    proc(file: string): Sound = newSound(file))

  buttonMosaic = newMosaic("data/gui/button.png", (8, 8))
  buttonSkin = newTextureGraphic()
  discard buttonSkin.assignTexture buttonMosaic.render(
    patternStretchBorder(8, 1))

  inputMosaic = newMosaic("data/gui/button.png", (8, 8))
  inputSkin = newTextureGraphic()
  discard inputSkin.assignTexture inputMosaic.render(
    patternStretchBorder(16, 1))


proc freeData*() =
  defaultFont.free()
  bigFont.free()
  for graphic in gfxData.values:
    graphic.free()
  for sound in sfxData.values:
    sound.free()
  buttonSkin.free()
  buttonMosaic.free()
  inputMosaic.free()
  inputSkin.free()

