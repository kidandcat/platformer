cd src
nim c --multimethods:on --out:..\sdl2\platformer.exe --threads:on --d:release --opt:speed platformer.nim
cd ..
nim c --d:release packer.nim