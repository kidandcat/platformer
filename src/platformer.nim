import
  nimgame2 / [
    audio,
    nimgame,
    settings,
    types,
  ],
  data,
  title,
  main


game = newGame()
if game.init(GameWidth, GameHeight, title = GameTitle, integerScale = true):

  # Init
  game.setResizable(true) # Window could be resized
  game.minSize = (GameWidth, GameHeight) # Minimal window size
  game.windowSize = (GameWidth * 2, GameHeight * 2) # Doulbe scaling (1280x720)
  game.centrify() # Place window at the center of the screen
  background = 0x151B8D'u32
  setSoundVolume Volume.high div 2 # set sound volume to a 50%

  loadData() # Call it before any scene initialization

  # Create scenes
  titleScene = newTitleScene()
  mainScene = newMainScene()

  # Run
  game.scene = titleScene # Initial scene
  run game # Let's go!

