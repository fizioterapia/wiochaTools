wT.AJS = wT.AJS or {}

util.AddNetworkString("wT.AJS::AdminJoined")

function wT.AJS.PlayerInitialSpawn(ply)
    if !IsValid(ply) then return end
    if !table.HasValue(wT.AJS.Config.GroupsPlayback, ply:GetUserGroup()) and !table.HasValue(wT.AJS.Config.AllowedUsers, ply:SteamID()) then return end

    net.Start("wT.AJS::AdminJoined")
    net.WriteEntity(ply)
    net.Broadcast()
end
hook.Add("PlayerInitialSpawn", "wT.AJS::PlayerInitialSpawn", wT.AJS.PlayerInitialSpawn)