local Sprite = require('text-sprite')

local Cat = setmetatable({}, { __index = Sprite })
catText = [[
 /\_/\
( o o )
==_Y_==
  `-']]

function Cat:new(world, font, x, y)
    local f = font or love.graphics.getFont()
    local instance = Sprite:new(world, font, catText, x, y, 1,0,0, 1)
    return instance
end

return Cat
