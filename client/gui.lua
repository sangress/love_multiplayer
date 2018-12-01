require 'game-state'

local GUIManager = {}

local draw = love.graphics.draw
local playBtn = {}
local settingsBtn = {}
local exitBtn = {}
local offsetY = 50
local btnHeight = 48

function _isOnTarget(x, y, btn)
    return x >= btn.x and x <= btn.x + btn.width and y >= btn.y and y <= btn.y + btn.height
end

function GUIManager:load()
    asm:add(love.graphics.newImage('assets/gui/main_menu/btn_play.png'), 'gui-btn_play')
    asm:add(love.graphics.newImage('assets/gui/main_menu/btn_settings.png'), 'gui-btn_settings')
    asm:add(love.graphics.newImage('assets/gui/main_menu/btn_exit.png'), 'gui-btn_exit')
end

function drawBtn(img, x, y)
    local btn = {}
    if img == nil then return nil end
    btn.width = img:getWidth()
    btn.height = img:getHeight()
    btn.x = x or (gWidth / 2) - (btn.width / 2)
    btn.y = y
    draw(img, btn.x, btn.y)

    return btn
end

function GUIManager:draw()
    playBtn     = drawBtn(asm:get('gui-btn_play'), nil, offsetY)
    settingsBtn = drawBtn(asm:get('gui-btn_settings'), nil, offsetY + (btnHeight * 1.5))
    exitBtn     = drawBtn(asm:get('gui-btn_exit'), gWidth - 50, offsetY - 30)
end



function GUIManager:onClick(x, y, button, istouch, presses)
    if _isOnTarget(x, y, playBtn) and gGameManager.getState() == GAME_STATE.MENU then
        gGameManager:loadGame()
    end
    if _isOnTarget(x, y, exitBtn) and gGameManager.getState() == GAME_STATE.MENU then
        gGameManager:exit()
    end
end

return GUIManager
