local Sprite = {}
Sprite.__index = Sprite

local defaultText = [[
 /\_/\
( o o )
==_Y_==
  `-']]

function Sprite:new(text, x, y)
    local instance = setmetatable({}, Sprite)
    instance.text = text or defaultText
    instance.x = x or 0 ;
    instance.y = y or 0 ; 
    instance.w = defaultText
    instance.h = "5"
    return instance
end

function Sprite:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.print(self.text, self.x, self.y)
end

return Sprite
