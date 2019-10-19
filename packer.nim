import osproc, os, tables

const gameData = static:
  var a = initTable[string, string]()
  for kind, path in walkDir("data"):
    if kind == pcDir:
      for kind, path in walkDir(path):
        a[path] = staticRead(path)
    if kind != pcFile: continue 
    a[path] = staticRead(path)
  a

const libsData = static:
  var a = initTable[string, string]()
  for kind, path in walkDir("sdl2"):
    if kind != pcFile: continue 
    a[path] = staticRead(path)
  a

createDir(getTempDir() & "sdl2")

for path, data in libsData:
  let (dir, fname) = splitPath(path)
  createDir(getTempDir() / dir)
  var f = open(getTempDir() / dir / fname, fmWrite)
  write(f, data)
  f.close()
for path, data in gameData:
  let (dir, fname) = splitPath(path)
  createDir(getTempDir() / "sdl2" / dir)
  var f = open(getTempDir() / "sdl2" / dir / fname, fmWrite)
  write(f, data)
  f.close()

discard execProcess(getTempDir() / "sdl2" / "platformer.exe", getTempDir() / "sdl2")

removeDir(getTempDir() / "sdl2")
