local Cat = require('cat')

local Player = setmetatable({}, { __index = Cat })

function Player:new(world, font, x, y)
    local f = font or love.graphics.getFont()
    local instance = Cat:new(world, font, x, y)
    return instance
end

return Player


