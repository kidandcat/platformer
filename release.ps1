cd src
nim c --out:..\platformer -d:release --opt:speed --app:gui platformer.nim
rmdir /s /q nimcache
cd ..