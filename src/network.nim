import ws, asyncdispatch, asynchttpserver, json

var socket: WebSocket

proc recvLoop() {.async, gcsafe.} =
  while socket.readyState == Open:
    var pkt = await socket.receiveStrPacket()
    echo pkt

proc send*(data: string) {.async, gcsafe.} =
  if socket.readyState == Open:
    await socket.send(data)

proc connect*() {.async, gcsafe.} =
  socket = await newWebSocket("ws://127.0.0.1:9001/ws")
  discard recvLoop()
