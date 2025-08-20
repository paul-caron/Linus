local Sprite = require('text-sprite')

local Cat = setmetatable({}, { __index = Sprite })
catText = [[
 /\_/\
( o o )
==_Y_==
  `-']]

function Cat:new(world, font, x, y)
    local f = font or love.graphics.getFont()
    local instance = Sprite:new(font, catText, x, y, 0.2,0.2,0.2,0, 1,0,0, 1)
    instance.body = love.physics.newBody(world, x, y, "dynamic")
    instance.body:setFixedRotation(true)    -- we’ll rotate manually if we want
    instance.body:setLinearDamping(2) -- friction
    instance.body:setMass(1)
    instance.body:setLinearVelocity(0, 0)
    instance.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1) -- density=1

    return instance
end

return Cat
