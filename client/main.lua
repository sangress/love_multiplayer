gGameManager        = require('game-manager')
gSettingsManager    = require('settings-manager')

function love.load()
    gSettingsManager:load()    
    gGameManager:load()
    math.randomseed(os.time())
end


-- TODO: make Player {x, y, pid}

function love.update(dt)     
    gGameManager:update(dt)
end

function love.draw()    
    gGameManager:draw()
end

-- local quit = true
function love.quit()
    -- TODO: ask if for sure
    -- if quit then
    --     print("We are not ready to quit yet!")
    --     quit = not quit
    -- else
    --     print("Thanks for playing. Please play again soon!")
    --     return quit
    -- end
    -- return true
    print('exit')    
    return false

end

-- TODO: onresize

function love.mousereleased(x, y, button, istouch, presses)
    guiManager:onClick(x, y, button, istouch, presses)
end

function love.mousepressed(x, y, button)
    gGameManager:mousepressed(x, y, button)
end
