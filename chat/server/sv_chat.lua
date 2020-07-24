RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:server:ClearChat')
RegisterServerEvent('__cfx_internal:commandFallback')

-- DoktorSAS
--[[
    Change the 33 to the maximum number of players allowed on the server.
    The following code is used to take a user's group value and save it. When a 
    player enters the server the script will save his rank and make him appear in chat
]]--
ESXUsersRank = {}
i = 0
while i < 33 do
    ESXUsersRank[i] = "user"
    i = i + 1
end
function setESXUserRank( _source, group )
    ESXUsersRank[tonumber(_source)] = group
end
RegisterNetEvent("SX:getESXGroup")
AddEventHandler("SX:getESXGroup", function()
    local _source = source
    MySQL.Async.fetchAll(
        "SELECT `group` FROM `users` WHERE `identifier` = @identifier",
        {['@identifier'] = GetPlayerIdentifier(_source)},
        function (results)
            TriggerClientEvent("SX:getESXGroup", _source, results[1].group)
            setESXUserRank( _source, results[1].group)
        end)
    print(ESXUsersRank[tonumber(_source)])
end)
----------------------------------------------------------------------------
AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message or not author then
        return
    end

    TriggerEvent('chatMessage', source,  author, message)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, author,  { 255, 255, 255 }, message)
    end

    print(author .. '^7: ' .. message .. '^7')
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, '/' .. command) 
    end

    CancelEvent()
end)

-- command suggestions for clients

--[[local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end]]--

AddEventHandler('chat:init', function()
    --refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        --refreshCommands(player)
    end
end)
