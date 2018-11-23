local enet = require "enet"
-- local host = enet.host_create("localhost:6789")

function love.load()
    host = enet.host_create("*:6789")
end

function love.update(dt)
    local event = host:service(100)
    print(event)
    if event then
        print('event')
        if event.type == "receive" then

        end
    end        
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    end
end
