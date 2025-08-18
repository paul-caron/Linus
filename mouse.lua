local Sprite = require('text-sprite')

local Mouse = setmetatable({}, { __index = Sprite })
local mouseText = [[
()-()
 \"/
  `]];

function Mouse:new(font, x, y)
    local f = font or love.graphics.getFont()
    local instance = Sprite:new(font, mouseText, x, y, 0.2,0.2,0.2,0, 1,1,1, 1)
    return instance
end

return Mouse
