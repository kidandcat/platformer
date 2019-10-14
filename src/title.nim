import
  nimgame2 / [
    assets,
    entity,
    font,
    gui/button,
    gui/widget,
    input,
    mosaic,
    nimgame,
    scene,
    settings,
    textgraphic,
    texturegraphic,
    types,
  ],
  data


type
  TitleScene = ref object of Scene


# Play action procedure
proc play(widget: GuiWidget) =
  echo "Play"
  game.scene = mainScene


# Exit action procedure
proc exit(widget: GuiWidget) =
  gameRunning = false


proc init*(scene: TitleScene) =
  echo "Title init"
  init Scene(scene)

  # Create menu buttons
  var
    btnPlay, btnExit: GuiButton
    btnPlayLabel, btnExitLabel: TextGraphic

  # Play button
  btnPlayLabel = newTextGraphic defaultFont
  btnPlayLabel.setText "PLAY"
  btnPlay = newGuiButton(buttonSkin, btnPlayLabel)
  btnPlay.centrify()
  btnPlay.pos = (GameWidth / 2, GameHeight / 2)
  btnPlay.actions.add play # assign the action procedure
  scene.add btnPlay

  # Exit button
  btnExitLabel = newTextGraphic defaultFont
  btnExitLabel.setText "EXIT"
  btnExit = newGuiButton(buttonSkin, btnExitLabel)
  btnExit.centrify()
  btnExit.pos = (GameWidth / 2, GameHeight / 2 + 64)
  btnExit.actions.add exit # assign the action procedure
  scene.add btnExit

  # Title text
  let titleText = newTextGraphic bigFont
  titleText.setText GameTitle
  let title = newEntity()
  title.graphic = titleText
  title.centrify()
  title.pos = (GameWidth / 2, GameHeight / 3)
  scene.add title


proc free*(scene: TitleScene) =
  discard


proc newTitleScene*(): TitleScene =
  new result, free
  init result


method show*(scene: TitleScene) =
  showCursor()


method event*(scene: TitleScene, event: Event) =
  scene.eventScene event
  if event.kind == KeyDown:
    case event.key.keysym.sym:
    of K_Space, K_Return:
      game.scene = mainScene # quick start
    else:
      discard

