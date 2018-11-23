local AssetManager = {}

function AssetManager:load()
    self.assets = {}
end

function AssetManager:add(asset, id)
    print('id', id, asset)
    local a = {asset = asset, id = id}
    table.insert(self.assets, a)
    return asset
end

function AssetManager:get(id)
    for i, a in ipairs(self.assets) do
        if a.id == id then
            return a.asset
        end
    end
end

return AssetManager
