import nimgame2 / [
    nimgame,
    settings,
    types,
    scene
  ],
  ws, asyncdispatch, asynchttpserver, json, npc, tables, threadpool, chan

const UPDATE_FREQ* = 1.0
var socket {.threadvar.}: WebSocket

proc recvLoop() {.async.} =
  while socket.readyState == Open:
    var pkt = await socket.receiveStrPacket()
    fromNetwork.send pkt

proc sendLoop() {.async.} =
  while true:
    let msg = recv toNetwork
    if socket.readyState == Open:
      await socket.send(msg)
    else:
      echo "socket closed"
      break

proc connect*() {.thread.} =
  socket = waitFor newWebSocket("ws://127.0.0.1:9001/ws")
  open toNetwork
  open fromNetwork
  asyncCheck recvLoop()
  asyncCheck sendLoop()
  runForever()