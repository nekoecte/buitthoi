-- local function alternateServersRequest()
--     local response = request({Url = 'https://games.roblox.com/v1/games/' .. tostring(game.PlaceId) .. '/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true', Method = "GET", Headers = { ["Content-Type"] = "application/json" },})

--     if response.Success then
--         return response.Body
--     else
--         return nil
--     end
-- end


 
-- local function getServer()
--         -- local servers
--         local servers

--         local success, _ = pcall(function()
--             servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. tostring(game.PlaceId) .. '/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true')).data
--         end)
    
--         if not success then
--             print("Error getting servers, using backup method")
--             servers = game.HttpService:JSONDecode(alternateServersRequest()).data
--         end
    

--         -- local server = servers[Random.new():NextInteger(1, 20)]
--     -- if server then
--     --     return server
--     -- else
--     --     return getServer()
--     -- end
--         local server = servers[Random.new():NextInteger(5, 100)]
    
--         if server then
--             return server
--         else
--             return getServer()
--         end
--     end

-- pcall(function()
--     game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, getServer().id, game.Players.LocalPlayer)
-- end)

-- task.wait(5)
-- while true do
--     game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
--     task.wait()
-- end


--222222222222222222222

-- local function alternateServersRequest()
--     local response = request({
--         Url = 'https://games.roblox.com/v1/games/' .. tostring(game.PlaceId) .. '/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true',
--         Method = "GET",
--         Headers = {
--             ["Content-Type"] = "application/json"
--         },
--     })

--     if response.Success then
--         return response.Body
--     else
--         return nil
--     end
-- end



-- local function getServer()

--     local servers

--     local success, _ = pcall(function()
--         servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. tostring(game.PlaceId) .. '/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true')).data
--     end)

--     if not success then
--         print("Error getting servers, using backup method")
--         servers = game.HttpService:JSONDecode(alternateServersRequest()).data
--     end
--     -- Lọc danh sách máy chủ để chỉ chọn các máy chủ có nhiều "balloon"
--     local filteredServers = {}
--     for _, server in ipairs(servers) do
--         if server.balloon > 50 then  -- Điều kiện có thể thay đổi tùy theo yêu cầu của bạn
--             table.insert(filteredServers, server)
--         end
--     end

--     -- Nếu không có máy chủ nào thỏa mãn điều kiện, chọn lại máy chủ
--     if #filteredServers == 0 then
--         return getServer()
--     end

--     -- Chọn một máy chủ từ danh sách máy chủ đã lọc
--     local chosenServer = filteredServers[Random.new():NextInteger(1, #filteredServers)]
--     return chosenServer
-- end

-- pcall(function()
--     game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, getServer().id, game.Players.LocalPlayer)
-- end)

-- task.wait(5)
-- while true do
--     game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
--     task.wait()
-- end
local MAX_ATTEMPTS = 3  -- Số lần tối đa thử hợp server

local function alternateServersRequest()
    local response = request({
        Url = 'https://games.roblox.com/v1/games/' .. tostring(game.PlaceId) .. '/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true',
        Method = "GET",
        Headers = {
            ["Content-Type"] = "application/json"
        },
    })

    if response.Success then
        return response.Body
    else
        return nil
    end
end

local function getServer()
    
    local attempt = 1
    local chosenServer

    while attempt <= MAX_ATTEMPTS do
        local servers

        local success, _ = pcall(function()
            servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. tostring(game.PlaceId) .. '/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true')).data
        end)

        if not success then
            print("Error getting servers, using backup method")
            servers = game.HttpService:JSONDecode(alternateServersRequest()).data
        end
        -- Lọc danh sách máy chủ để chỉ chọn các máy chủ có nhiều "balloon"
        local filteredServers = {}
        for _, server in ipairs(servers) do
            if server.balloon > 50 then  -- Điều kiện có thể thay đổi tùy theo yêu cầu của bạn
                table.insert(filteredServers, server)
            end
        end

        -- Nếu không có máy chủ nào thỏa mãn điều kiện, chọn lại máy chủ
        if #filteredServers == 0 then
            attempt = attempt + 1
            print("No suitable server found. Attempting to select another server...")
            task.wait(2)  -- Đợi 2 giây trước khi thử lại
        else
            -- Chọn một máy chủ từ danh sách máy chủ đã lọc
            chosenServer = filteredServers[Random.new():NextInteger(1, #filteredServers)]
            break
        end
    end

    if not chosenServer then
        error("Failed to select a server after maximum attempts")
    end

    return chosenServer
end

pcall(function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, getServer().id, game.Players.LocalPlayer)
end)

task.wait(5)
while true do
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    task.wait()
end
