--cache clearing for development stage
package.loaded["text-sprite"] = nil
package.loaded["mouse"] = nil
package.loaded["cat"] = nil
package.loaded["controls"] = nil

--imports
local Sprite = require("text-sprite")
local Mouse = require("mouse")
local Cat = require("cat")
local controls = require("controls")

--globals
local sprites = {} --drawable textual sprites objects
local keys = {} --keypressed keys[key] = true or false
local player = nil --main hero sprite (cat)
local font = nil --game font
local canvas = nil --a separate window to draw to that isnt affected by glClear
local fadeAlpha = 0.17

function love.load()
    debugMode = os.getenv("DEBUG")
    if(debugMode == "1") then
        print("Load")
    end

    --random RNG init
    local seed = os.time()
    math.randomseed(seed)

    --font init
    local font = love.graphics.newFont('assets/courier-prime/Courier Prime.ttf', 24)

    --canvas init
    canvas = love.graphics.newCanvas()

    --player init
    player = Cat:new(font, 0, 0)

    --mice init
    for i = 0, 5, 1 do
        local x = math.random() * love.graphics.getWidth();
        local y = math.random() * love.graphics.getHeight();
        local mouse = Mouse:new(font, x, y)
        table.insert(sprites, mouse)
    end
end

function love.update(dt)
    --controls
    controls(player, keys)

    --collision check
    for i, sprite in ipairs(sprites) do
        if player:collide(sprite) then
            sprite.dead = true; -- mouse killed
        end
    end

    --remove dead mouse
    for i = #sprites, 1, -1 do   -- iterate backwards
        if sprites[i].dead == true then
            table.remove(sprites, i)
        end
    end
end

function love.draw()
    --draw onto canvas
    love.graphics.setCanvas(canvas)
    love.graphics.setColor(0, 0, 0, fadeAlpha)  -- RGB(0,0,0) + alpha
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    --draw player
    player:draw()
    for index, sprite in ipairs(sprites) do
         sprite:draw()
    end

    --switch back to drawing on screen
    love.graphics.setCanvas(nil)

    --draw canvas content on screen
    love.graphics.draw(canvas, 0, 0)
end

function love.keypressed(key, scancode, isRepeat)
    if(debugMode == "1") then
        print("Key Pressed: " .. "\n\tKey: " .. key .. ", \n\tScancode: " .. scancode .. ", \n\tisRepeat: " .. tostring(isRepeat) )
    end
    if key == "escape" then
        love.event.quit()
    end
    keys[key] = true
end

function love.keyreleased(key, scancode)
    if(debugMode == "1") then
        print("Key Released: " .. "\n\tKey: " .. key .. ", \n\tScancode: " .. scancode )
    end
    keys[key] = false
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
