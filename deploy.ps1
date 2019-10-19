scp server.nim root@galax.be:/root
ssh root@galax.be "nim c server.nim"
ssh root@galax.be "pm2 restart nim"