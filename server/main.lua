require 'utils/table-utils'
local json = require 'utils/json'
local enet = require "enet"
local players = {}
local MAX_CHANNEL_PLAYERS = 50

function love.load()
    host = enet.host_create("localhost:6789")    
end

function love.update(dt)
    local event = host:service(100)

    if event then        
        if event.type == "receive" then
            -- print("Got message: ", event.data, event.peer)
            if event.data ~= nil then
                local data = json.decode(event.data)        
                if data.type == 'disconnect' then
                    return
                end        
                -- TODO: make it better
                local isNew = true
                for i = 1, #players do
                    if players[i].pid == data.pid then
                        local player = players[i]
                        for k, v in pairs(player) do
                            if data[k] ~= nil then
                                player[k] = data[k]
                            end
                        end
                        isNew = false
                    end
                end

                local channel = data.channel or event.channel
                
                
                if isNew then
                    if #getPlayersOnChannel(players, channel) >= MAX_CHANNEL_PLAYERS then
                        channel = channel + 1
                    end
                        
                    data.channel = channel
                    data.peer = tostring(event.peer)                                        
                    table.insert(players, data)                
                end
                
                host:broadcast(json.encode({channel = channel, players = getPlayersOnChannel(players, channel), isNew = isNew, pid = data.pid}))
            end

            
          elseif event.type == "connect" then
            print(event.peer, "connected.")
          elseif event.type == "disconnect" then
            print(table.toString(event), "disconnected.")            
            removePlayerFromPeer(event.peer)
          end
          event = host:service()
    end        
end

function removePlayerFromPeer(peer)
    for i = 1, #players do
        if players[i] ~= nil and players[i].peer == tostring(peer) then
            print('found player')
            table.remove(players, i)
        end
    end
end

function getPlayersOnChannel(players, channel)
    local channelPlayers = {}
    for i = 1, #players do
        if players[i].channel == channel then
            table.insert(channelPlayers, players[i])
        end
    end
    return channelPlayers
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    end
end
