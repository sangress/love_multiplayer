local Vector2D = require('utils/Vector2D')


-- local variables improves performance because lua doesn't need to go look in the hierarcy
local lg        = love.graphics
local pop       = lg.pop
local translate = lg.translate
local rotate    = lg.rotate
local scale     = lg.scale
local push      = lg.push

local Camera = {    
    pos     = Vector2D:new(0, 0),
    size    = Vector2D:new(0, 0),
    scale   = Vector2D:new(1, 1),
    rot     = 0
}

function Camera:set() 
    push()    
    rotate(-self.rot)
    scale(1 / self.scale.x, 1 / self.scale.y)
    translate(-self.pos.x, -self.pos.y)
end
function Camera:unset() 
    pop()
end

function Camera:setScale(x, y)
    self.scale.x = x or self.scale.x
    self.scale.y = y or self.scale.y
end

-- TODO: no global width (take from config?)
function Camera:move(pos, dx, dy)
    -- self.pos.x = pos.x - (gWidth / 2) -- * self.scale.x
    -- self.pos.y = pos.y - (gHeight / 2) -- * self.scale.y
    self.pos.x = pos.x - (gWidth / 2)
    self.pos.y = pos.y - (gHeight / 2)
end

return Camera
