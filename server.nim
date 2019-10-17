import ws, asyncdispatch, asynchttpserver

var connections = newSeq[WebSocket]()

proc cb(req: Request) {.async, gcsafe.} =
  echo "new conn"
  if req.url.path == "/ws":
    try:
      var ws = await newWebSocket(req)
      connections.add ws
      while ws.readyState == Open:
        let packet = await ws.receiveStrPacket()
        echo packet
        echo "connections length " & $connections.len
        for other in connections:
          if other.readyState == Open:
            echo "send to other " & packet
            asyncCheck other.send(packet)
    except IOError, WebSocketError:
      echo "socket closed"
  await req.respond(Http200, "Hello World")

var server = newAsyncHttpServer()
waitFor server.serve(Port(9001), cb)