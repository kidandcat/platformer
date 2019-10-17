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
  echo "while socket.readyState == Open"
  echo "socket.readyState " & $socket.readyState
  while socket.readyState == Open:
    echo "waiting for new packet"
    var pkt = await socket.receiveStrPacket()
    echo "new packet " & pkt
    fromNetwork.send pkt
  echo "Socket closed"

proc sendLoop() {.async.} =
  while true:
    echo "waiting toNetwork"
    let msg = recv toNetwork
    echo "toNetwork " & msg
    if socket.readyState == Open:
      await socket.send(msg)
    else:
      echo "socket closed"
      break

proc connect*() {.thread.} =
  echo "connect ws"
  socket = waitFor newWebSocket("ws://127.0.0.1:9001/ws")
  open toNetwork
  open fromNetwork
  echo "spawn recvLoop"
  asyncCheck recvLoop()
  echo "sendLoop"
  asyncCheck sendLoop()
  runForever()