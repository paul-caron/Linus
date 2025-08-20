--utils
local function splitString(str, delimiter)
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

-- Split text by lines using the custom split function.
local function splitTextByLines(text)
    return splitString(text, "\n")
end

--class exported
local Sprite = {}
Sprite.__index = Sprite

defaultText = [[
 /\_/\
( o o )
==_Y_==
  `-']]

function Sprite:new(world, font, text, x, y, r, g, b, a) 
    local instance = setmetatable({}, Sprite)
    instance.font = font or love.graphics.getFont()
    instance.text = text or defaultText
    instance.x = x or 0
    instance.y = y or 0
    instance.lines = splitTextByLines(instance.text)
    instance.r = r or 1
    instance.g = g or 0
    instance.b = b or 0
    instance.a = a or 1
    instance:initWidth()
    instance:initHeight()

    instance.body = love.physics.newBody(world, x, y, "dynamic")
    instance.body:setFixedRotation(true)    -- we’ll rotate manually if we want
    instance.body:setLinearDamping(2) -- friction
    instance.body:setMass(1)
    instance.body:setLinearVelocity(0, 0)

    instance.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.fixture = love.physics.newFixture(instance.body, instance.shape, 1) -- density=1

    return instance
end

function Sprite:initHeight()
    local y = 0
    for i, line in ipairs(self.lines) do
        y = y + self.font:getHeight(line) --increase vertical line offset for the next line
    end
    self.height = y
end

function Sprite:initWidth()
    local maxWidth = 0
    for i, line in ipairs(self.lines) do
        local width = self.font:getWidth(line)
        if maxWidth < width then
            maxWidth = width
        end
    end
    self.width = maxWidth
end

function Sprite:setForegroundColor(r,g,b,a)
    self.r = r
    self.g = g
    self.b = b
    self.a = a
end

function Sprite:draw()
    local y = 0 --line y vertical offset
    if(self.width == nil) then
        self:initWidth()
    end
    if(self.height == nil) then
        self:initHeight()
    end
    love.graphics.setFont(self.font)
    for i, line in ipairs(self.lines) do
        love.graphics.setColor(self.r, self.g, self.b, self.a)
        love.graphics.print(line, self.x, self.y + y)
        y = y + self.font:getHeight(line) --increase vertical line offset for the next line
    end
end

function Sprite:drawShape()
    local x, y = self.shape:getPoints()

        -- Draw a filled rectangle at the body's position for better visibility
    love.graphics.rectangle("line", self.x + self.width / 2 + x,
                            self.y + self.height / 2 + y,
                            self.width, self.height)

end

function Sprite:updatePosition()
    local x, y = self.body:getPosition()
    self.x = x - self.width / 2
    self.y = y - self.height / 2
end

function Sprite:collide(other) -- other is type Sprite
    if(self.width == nil) then
        self:initWidth()
    end
    if(self.height == nil) then
        self:initHeight()
    end
    return not (self.x + self.width < other.x or
                other.x + other.width < self.x or
                self.y + self.height < other.y or
                other.y + other.height < self.y)
end

return Sprite
