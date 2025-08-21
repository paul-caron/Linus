--cache clearing for development stage
package.loaded["text-sprite"] = nil
package.loaded["mouse"] = nil
package.loaded["cat"] = nil
package.loaded["cheese"] = nil
package.loaded["controls"] = nil
package.loaded["player"] = nil

--imports
local Sprite = require("text-sprite")
local Mouse = require("mouse")
local Cat = require("cat")
local Cheese = require("cheese")
local Player = require("player")
local controls = require("controls")

--configs
local ACCEL     = 800       -- pixels / second²
local MAX_SPEED = 500       -- pixels / second
local DRAG      = 300       -- pixels / second² when no key is pressed

--other globals
local sprites = {} --drawable textual sprites objects
local player = nil --main hero sprite (Linus the cat)
local cheese = nil --the treasure that the hero must guard
local world = nil --the physics world
local font = nil --text font
local canvas = nil --a separate window to draw to that isnt affected by glClear
local fadeAlpha = 0.7 -- the canvas clear color alpha for ghost like movement effect
local debugMode = nil -- for debugging purpose, monitors inputs, draws sprites shapes.

function love.load()
    debugMode = os.getenv("DEBUG")
    if(debugMode == "1") then
        print("Load")
    end

    --random RNG init
    local seed = os.time()
    math.randomseed(seed)

    --font init
    local font = love.graphics.newFont('assets/Courier Prime.ttf', 24)

    --canvas init
    canvas = love.graphics.newCanvas()

    -- 64 pixels = 1 meter (feel free to change this)
    love.physics.setMeter(64)

    -- gravity vector (x, y): 0, 0 because it’s top‑down
    world = love.physics.newWorld(0, 0, true)

    --player init
    player = Player:new(world, font, 400, 300)
    cheese = Cheese:new(world, font, 400, 400)

    --mice init
    for i = 0, 5, 1 do
        local x = math.random() * love.graphics.getWidth();
        local y = math.random() * love.graphics.getHeight();
        local mouse = Mouse:new(world, font, x, y)
        table.insert(sprites, mouse)
    end
end

function love.update(dt)
    -- physics world step
    world:update(dt)

    -- Player Movement
    -- decide acceleration / braking
    local ax, ay = controls.getMovementVector()

    if ax ~= 0 or ay ~= 0 then
        -- apply force in the direction the key(s) are pressed
        local forceX = ax * ACCEL
        local forceY = ay * ACCEL
        player.body:applyForce(forceX, forceY)
    else
        -- no key → apply linear drag (anti‑friction) to slow down
        local vx, vy = player.body:getLinearVelocity()
        local speed = math.sqrt(vx ^ 2 + vy ^ 2)

        if speed > 0 then
            local drag = math.min(DRAG * dt, speed)   -- don’t over‑drag
            local ndx, ndy = -vx / speed, -vy / speed -- direction of drag
            local dragX, dragY = ndx * drag, ndy * drag
            player.body:applyForce(dragX, dragY)
        end
    end

    -- clamp speed to MAX_SPEED
    local vx, vy = player.body:getLinearVelocity()
    local speed = math.sqrt(vx ^ 2 + vy ^ 2)
    if speed > MAX_SPEED then
        local factor = MAX_SPEED / speed
        player.body:setLinearVelocity(vx * factor, vy * factor)
    end

    --update player's position
    player:updatePosition()

    --cheese update
    cheese:updatePosition()

    --update sprites positions
    for i, sprite in ipairs(sprites) do
        sprite:updatePosition()
    end
    

    -- Collision Player and Mice
    --collision check
    for i, sprite in ipairs(sprites) do
        if player:collide(sprite) then
--            sprite.dead = true; -- mouse killed
        end
    end

    --remove dead mouse
    for i = #sprites, 1, -1 do   -- iterate backwards
        if sprites[i].dead == true then
--            table.remove(sprites, i)
        end
    end
end

function love.draw()
    --draw onto canvas
    love.graphics.setCanvas(canvas)
    love.graphics.setColor(0, 0, 0, fadeAlpha) -- rbga
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    --draw player
    player:draw()

    --draw cheese
    cheese:draw()

    if (debugMode == "1" and player.shape) then
        player:drawShape() -- draws the physics engine shape
    end

    --draw all other sprites
    for index, sprite in ipairs(sprites) do
         sprite:draw()
        if (debugMode == "1" and sprite.shape) then
            sprite:drawShape() -- draws the physics engine shape
        end
    end

    --switch back to drawing on screen
    love.graphics.setCanvas(nil)

    --draw canvas content on screen
    love.graphics.draw(canvas, 0, 0)

end




-- Inputs debugging section
function love.keypressed(key, scancode, isRepeat)
    if(debugMode == "1") then
        print("Key Pressed: " .. "\n\tKey: " .. key .. ", \n\tScancode: " .. scancode .. ", \n\tisRepeat: " .. tostring(isRepeat) )
    end
    if key == "escape" then
        love.event.quit()
    end
end

function love.keyreleased(key, scancode)
    if(debugMode == "1") then
        print("Key Released: " .. "\n\tKey: " .. key .. ", \n\tScancode: " .. scancode )
    end
end

function love.restart()
    if(debugMode == "1") then
        print("Restart")
    end
end

function love.textinput(text)
    if(debugMode == "1") then
        print("Text Input: " .. "\n\tText: " .. text )
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if(debugMode == "1") then
        print("Mouse Pressed: " .. "\n\tx: " .. x .. "\n\ty: " .. y .. "\n\tbutton: " .. button .. "\n\tistouch: " .. tostring(istouch) .. "\n\tpresses: " .. presses)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if(debugMode == "1") then
        print("Mouse Released: " .. "\n\tx: " .. x .. "\n\ty: " .. y .. "\n\tbutton: " .. button .. "\n\tistouch: " .. tostring(istouch) .. "\n\tpresses: " .. presses)
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if(debugMode == "1") then
        print("Mouse Moved: " .. "\n\tx: " .. x .. "\n\ty: " .. y .. "\n\tdx: " .. dx .. "\n\tdy: " .. dy .. "\n\tistouch: " .. tostring(istouch) )
    end
end

function love.wheelmoved(x, y)
    if(debugMode == "1") then
        print("Mouse Wheel Moved: " .. "\n\tx: " .. x .. "\n\ty: " .. y )
    end
end

function love.resize(w, h)
    if(debugMode == "1") then
        print("Resize: " .. "\n\tw: " .. w .. "\n\th: " .. h)
    end
end

function love.focus(f)
    if(debugMode == "1") then
        print("Focus: " .. tostring(f))
    end
end

function love.quit()
    if(debugMode == "1") then
        print("Quit")
    end
end

function love.errorhandler(err)
    print("ErrorHandler: " .. "\n\terr: " .. err)
end
