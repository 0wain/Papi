local xAdmin = xAdmin -- avoid global lookups
if not xAdmin then return end
if not xAdmin.Github then return end

local pairs = pairs

-- To avoid cost of Player.__index lookups
local PLAYER = FindMetaTable("Player")

---@type PapiAPI
local api = {
    Name = "xAdmin (Github)",
    Commands = {}
}

function api.AddPermission(name, min_access, category)
    // Not quote sure what this does
end

function api.GetPermissions()
    local commands = xAdmin.Commands
    local all, n = {}, 1

    for k, v in pairs(commands) do
        all[n] = k; n = n + 1
    end

    return all
end

function api.PlayerHasPermission(ply, perm_name)
    local command = xAdmin.Core.IsCommand(perm_name)

    return ply:HasPower(command.power)
end

function api.GetPlayersWithPermission(perm_name)
    local players, n = {}, 1

    for _, ply in player.Iterator() do
        if api.PlayerHasPermission(ply, perm_name) then
            players[n] = ply; n = n + 1
        end
    end

    return players
end

function api.GetPlayerRoles(ply)
    return { ply:GetUserGroup() }
end

function api.GetRoles()
    local all, n = {}, 1
    for k, v in pairs(xAdmin.Groups) do
        all[n] = k; n = n + 1
    end
    return all
end

function api.OnRoleChanges(identifier, func)
end

if SERVER then
    function api.IsSteamid64Banned(steamid64, callback)
        xAdmin.Database.IsBanned(steamid64, function(data)
            if data and data[1] then
                if (tonumber(data[1].duration) == 0) or ((data[1].start + data[1].duration) > os.time()) then
                    return true
                else
                    return false
                end
            end
        end)
    end
end

function api.Commands.Kick(ply, reason)
    RunConsoleCommand("xadmin", "kick", ply:SteamID64(), reason)
end

function api.Commands.BanID64(steamid64, length, reason)
    RunConsoleCommand("xadmin", 'ban', steamid64, length, reason)
end

function api.Commands.Ban(ply, length, reason)
    api.Commands.BanID64(ply:SteamID64(), length, reason)
end

function api.Commands.UnbanID64(steamid64)
    RunConsoleCommand("xadmin", 'unban', steamid64)
end

function api.Commands.Freeze(ply)
    print('freeze', ply:SteamID64())
    RunConsoleCommand("xadmin", 'freeze', ply:SteamID())
end

function api.Commands.Unfreeze(ply)
    RunConsoleCommand("xadmin", 'unfreeze', ply:SteamID64())
end

if CLIENT then
    function api.Commands.Goto(ply)
        RunConsoleCommand("xadmin", 'goto', ply:SteamID64())
    end

    function api.Commands.Bring(ply)
        RunConsoleCommand("xadmin", 'bring', ply:SteamID64())
    end

    function api.Commands.Return(ply)
        RunConsoleCommand("xadmin", 'return', ply:SteamID64())
    end
end

return api
