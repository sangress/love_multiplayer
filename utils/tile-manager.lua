local config = require('config')
local Vector2D = require('utils/vector2d')

local tlm = {}

local quad = love.graphics.newQuad

-- TODO: take config from tilemap

local y = 6
local x = 8
local tileWidth = config.tileWidth
local tileHeight = config.tileHeight
local tilesheetWidth = config.tilesheetWidth
local tilesheetHeight = config.tilesheetHeight

local quads = {}
for i = 0, y - 1 do
    for j = 0, x - 1 do
       table.insert(quads, quad((tileWidth * j), (tileWidth * i), tileWidth, tileHeight, tilesheetWidth, tilesheetHeight))        
    end
end

function tile(x, y, w, h, quad)
    local tile = {}

    tile.pos = Vector2D:new(x, y)
    tile.size = Vector2D:new(w, h)
    tile.quad = quad

    return tile
end

function tlm:load()
    self.tiles = {}
    self.img = asm:get("lvl1_tiles")
    self.img:setFilter("nearest", "nearest")

    renderer:addRenderer(self)
end

function tlm:loadMap(mapName)
    local map = require('assets/maps/'..mapName)    

    for i = 1, map.height do self.tiles[i] = {} end    

    for layer = 1, #map.layers do 
        local data = map.layers[layer].data
        local propt = map.layers[layer].prop

        for y = 1, map.height do
            for x = 1, map.width do
                -- take index from the tiles array
                local index = (y * map.height + (x + 1) - map.width) + 1

                -- if data is not zero then we have a tile to draw
                if data[index] ~= 0 then                    
                    local q = quads[data[index]]
                    -- TODO: 16 -> config.tileSize
                    -- self.tiles[y][x] = tile((16 * x) - 16, (16 * y) - 16, 16, 16, q)
                    -- print('x', x)
                    self.tiles[y][x] = tile((tileWidth * x) - tileWidth, (tileHeight * y) - tileHeight, tileWidth, tileHeight, q)
                end
            end
        end
    end
end

function tlm:draw()
    for i = 1, #self.tiles do
        -- for j = 1, #self.tiles[i] do
        for j = 1, #self.tiles do
            if self.tiles[i][j] ~= nil then
                local tile = self.tiles[i][j]
                if tile.quad ~= nil then 
                    love.graphics.draw(self.img, tile.quad, tile.pos.x, tile.pos.y)
                end
            end
        end
    end
end

function tlm:destroy() 
end

return tlm
