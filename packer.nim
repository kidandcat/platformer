import osproc, os, tables

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

discard execProcess(getTempDir() & "sdl2\\platformer.exe")

for name, data in libsData:
  removeFile(getTempDir() & name)
