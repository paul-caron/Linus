local controls  = {}

-- get player's movement vector
controls.getMovementVector = function ()
    local vx, vy = 0, 0

    if love.keyboard.isDown("a", "left")  then vx = vx - 1 end
    if love.keyboard.isDown("d", "right") then vx = vx + 1 end
    if love.keyboard.isDown("w", "up")    then vy = vy - 1 end
    if love.keyboard.isDown("s", "down")  then vy = vy + 1 end

    -- Normalize if we’re actually moving, to keep diagonal speed same
    if vx ~= 0 or vy ~= 0 then
        local len = math.sqrt(vx * vx + vy * vy)
        vx, vy = vx / len, vy / len
    end

    return 0, 0
end

return controls
