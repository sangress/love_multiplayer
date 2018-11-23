local Vector2D = {}

function Vector2D:new(x, y)
    local vector2d = {}

    vector2d.x = x or 0
    vector2d.y = y or 0

    function vector2d:move(nx, ny, dt)
        local delta = dt or 1
        self.x = self.x + nx * delta
        self.y = self.y + ny * delta
    end

    return vector2d
end

return Vector2D
