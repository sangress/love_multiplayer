require 'game-state'

local enet          = require "enet"
local json          = require 'utils/json'
local tlm           = require 'utils/tile-manager'
local Renderer      = require 'utils/renderer'
local camera        = require('utils/camera')
local GameManager   = {}
local server        = {}

--globals
asm = require 'utils/asset-manager'
guiManager = require('gui')
renderer = Renderer:create()
gWidth = love.graphics.getWidth()
gHeight = love.graphics.getHeight()

-- TODO: local player = {} or module
-- locals
local x = 64
local y = 64
local speed = 200
local players = {}
local isConnected = false
local isCom = false
local channel = 0
local isMapSet = false
local state = GAME_STATE.MENU
local projectiles = {}
local projectileSpeed = 250
local MAX_PROJECTILES = 50
local rateTimer = 0
local updateRate = 0.01

function setState(newState)
    state = newState
    if state == GAME_STATE.MENU then
        isCom = false
        isConnected = false
    end
end

function GameManager:loadGame()
    setState(GAME_STATE.LOAD)
    tlm:load()
    tlm:loadMap('new-desert')    

    self.connectServer()
end

function GameManager:getState()
    return state
end

function GameManager:exit()
    love.event.push("quit")
end

function GameManager:connectServer()
    host = enet.host_create()
    server = host:connect("localhost:6789")
end

function updateBullets(dt)
    for i,v in ipairs(projectiles) do
        v.x = v.x + (v.dx * dt)
        v.y = v.y + (v.dy * dt)
    end      
    
    if #projectiles > MAX_PROJECTILES then
        projectiles = {}
    end
end

function GameManager:update(dt)     
    if server and self.getState() ~= GAME_STATE.MENU then
        if (isConnected and isCom ~= true) then
            -- print('init new player')
            pid = math.random(9999)
            host:broadcast(json.encode({x = x, y = y, pid = pid, projectiles = projectiles}))
            isCom = true
            setState(GAME_STATE.PLAY)
        end

        rateTimer = rateTimer + dt
        if rateTimer > updateRate then

            local event = host:service(100)        
            local playerX = x
            local playerY = y
            if love.keyboard.isDown('d') then
                x = x + (speed * dt)
            end
            if love.keyboard.isDown('a') then
                x = x - (speed * dt)
            end
            if love.keyboard.isDown('w') then
                y = y - (speed * dt)
            end
            if love.keyboard.isDown('s') then
                y = y + (speed * dt)
            end
            
            if playerX ~= x or playerY ~= y then
                host:broadcast(json.encode({x = x, y = y, pid = pid, channel = channel, projectiles = projectiles}))
            end

            if event then            
                if event.type == "receive" then
                    -- print("Got message: ", event.channel, event.peer)
                    if event.data ~= nil then
                        local data = json.decode(event.data)
                        if data.isNew and data.pid == pid then
                            channel = data.channel
                        end

                        if data.channel == channel then
                            players = data.players 
                        end
                    end
                                    
                elseif event.type == "connect" then
                    print(event.peer, "connected.")
                    isConnected = true
                elseif event.type == "disconnect" then
                    print(event.peer, "disconnected.")
                    isConnected = false
                    isCom = false
                    host:broadcast(pid)                
                end
                event = host:service()
            end

            updateBullets(dt)    
            rateTimer = rateTimer - updateRate    
        end
    end
end

function GameManager:draw()               
    if state == GAME_STATE.MENU then
        guiManager:draw()
    end
    if state == GAME_STATE.PLAY then        
        camera:set()    
        renderer:draw()        
        camera:move({x = x, y = y}, gWidth, gHeight)
        love.graphics.circle('fill', x, y, 16, 16)
        -- TODO: move to function
        for i = 1, #players do
            local player = players[i]                    
            if player.pid ~= pid then
                love.graphics.circle('fill', player.x, player.y, 16, 16)                    
            end
            
            -- TODO: optimize nearby
            -- for i, v in ipairs(projectiles) do
            --     love.graphics.circle("fill", v.x, v.y, 3)    
            -- end        
        end        
        camera:unset()
    end        
end

function GameManager:load()
    asm:load()      
    guiManager:load()  
    asm:add(love.graphics.newImage('assets/sprites/desert.png'), "lvl1_tiles")
end

function love.keypressed(key)    
    if key == "escape" then
        if state == GAME_STATE.MENU then
            love.event.push("quit")
        end

        setState(GAME_STATE.MENU)
    end
    if key == "p" then
        -- love.event.push("quit")
        gGameManager:loadGame()
    end
end

function GameManager:mousepressed(mouseX, mouseY, button)
    if button == 1 and self.getState() == GAME_STATE.PLAY then
        local startX = x + 16 / 2
		local startY = y + 16 / 2 
        local angle = math.atan2((mouseY - startY), (mouseX - startX))
        
        table.insert(projectiles, {x = startX, y = startY, dx = projectileSpeed * math.cos(angle), dy = projectileSpeed * math.sin(angle)})        
        host:broadcast(json.encode({x = playerX, y = playerY, pid = pid, channel = channel, projectiles = projectiles}))
    end
end

return GameManager
