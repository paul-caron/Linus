function controls(player, keys)
    if(keys["up"]) then
        player.y = player.y - 1
    end
    if(keys["down"]) then
        player.y = player.y + 1
    end
    if(keys["left"]) then
        player.x = player.x - 1
    end
    if(keys["right"]) then
        player.x = player.x + 1
    end
end

return controls
