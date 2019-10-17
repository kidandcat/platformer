import threadpool

var fromNetwork*: system.Channel[string]
var toNetwork*: system.Channel[string]
var sendWS*: system.Channel[string]
var receiveWS*: system.Channel[string]