local Sprite = require('text-sprite')

local Mouse = setmetatable({}, { __index = Sprite })
local mouseText = [[
()-()
 \"/
  `]];

function Mouse:new(world, font, x, y)
    local f = font or love.graphics.getFont()
    local instance = Sprite:new(world, font, mouseText, x, y, 1,1,1, 1)
    instance.body:setMass(0.025)
    return instance
end

return Mouse
