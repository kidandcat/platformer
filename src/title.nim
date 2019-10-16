import
  nimgame2 / [
    assets,
    entity,
    font,
    gui/button,
    gui/widget,
    gui/textinput,
    input,
    mosaic,
    nimgame,
    scene,
    settings,
    textgraphic,
    texturegraphic,
    types,
  ],
  data,
  main,
  strutils


type
  TitleScene = ref object of Scene

var
  btnPlay, btnExit: GuiButton
  btnPlayLabel, btnExitLabel: TextGraphic
  nameInput: GuiTextInput


# Play action procedure
proc play(widget: GuiWidget) =
  game.scene = mainScene


# Exit action procedure
proc exit(widget: GuiWidget) =
  gameRunning = false


proc init*(scene: TitleScene) =
  init Scene(scene)

  # Name input
  nameInput = newGuiTextInput(inputSkin, defaultFont)
  nameInput.pos = (GameWidth / 2 - (8 * 9), GameHeight / 2)
  nameInput.text.limit = 16 # set text length limit
  scene.add nameInput

  # Play button
  btnPlayLabel = newTextGraphic defaultFont
  btnPlayLabel.setText "PLAY"
  btnPlay = newGuiButton(buttonSkin, btnPlayLabel)
  btnPlay.centrify()
  btnPlay.pos = (GameWidth / 2, GameHeight / 2 + 60)
  btnPlay.actions.add play # assign the action procedure
  btnPlay.disable
  scene.add btnPlay

  # Exit button
  btnExitLabel = newTextGraphic defaultFont
  btnExitLabel.setText "EXIT"
  btnExit = newGuiButton(buttonSkin, btnExitLabel)
  btnExit.centrify()
  btnExit.pos = (GameWidth / 2, GameHeight / 2 + 88)
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
  if event.kind == KeyUp:
    playerName = nameInput.text.text # playerName is on main
    playerName.removeSuffix("|")
    if nameInput.text.text.len <= 3:
      btnPlay.disable
    else:
      btnPlay.enable
    

