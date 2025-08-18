local Sprite = require('text-sprite')

local Cat = setmetatable({}, { __index = Sprite })
catText = [[
 /\_/\
( o o )
==_Y_==
  `-']]

function Cat:new(font, x, y)
    local f = font or love.graphics.getFont()
    local instance = Sprite:new(font, catText, x, y, 0.2,0.2,0.2,0, 1,0,0, 1)
    return instance
end

return Cat
