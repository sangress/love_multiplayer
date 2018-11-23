-- server.lua
local enet = require "enet"
local host = enet.host_create("localhost:6789")
while true do
  local event = host:service(100)
  while event do
    if event.type == "receive" then
      print("Got message: ", event.data, event.peer)
      event.peer:send( "pong" )
    elseif event.type == "connect" then
      print(event.peer, "connected.")
    elseif event.type == "disconnect" then
      print(event.peer, "disconnected.")
    end
    event = host:service()
  end
end
