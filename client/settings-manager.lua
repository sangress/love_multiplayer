local SettingsManager = {}

function SettingsManager:load()
    local file = {}
    if love.filesystem.getInfo('settings.json') == nil then
        file = love.filesystem.newFile('settings')
        file:close()
        print('dir', love.filesystem.getSaveDirectory())
    end

    print('settings-info', love.filesystem.getInfo('settings.json'))
end

return SettingsManager
