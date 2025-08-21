local Sprite = require('text-sprite')

local Cheese = setmetatable({}, { __index = Sprite })
cheeseText = [[
    _--"-.
 .-"      "-.
|""--..      '-.
|      ""--..   '-.
|.-. .-".    ""--..".
|'./  -_'  .-.      |
|      .-. '.-'   .-'
'--..  '.'    .-  -.
     ""--..   '_'   :
           ""--..   |
                 ""-']]

function Cheese:new(world, font, x, y)
    local f = font or love.graphics.getFont()
    local instance = Sprite:new(world, font, cheeseText, x, y, 1,1,0, 1)
    return instance
end

return Cheese
