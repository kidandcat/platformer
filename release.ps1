cd src
nim c --out:..\platformer --multimethods:on -d:release --opt:speed --app:gui platformer.nim
rmdir /s /q nimcache
cd ..