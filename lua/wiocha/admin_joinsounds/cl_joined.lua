wT.AJS = wT.AJS or {}

function wT.AJS.Draw()
    if !wT.AJS.Admin or !IsValid(wT.AJS.Admin) or wT.AJS.Start + 15 < CurTime() then return end

    local opacity = 255

    if wT.AJS.Start + 1 > CurTime() then
        local t = ((CurTime() - (wT.AJS.Start))) 
        opacity = Lerp(t, 0, 255)
    end

    if wT.AJS.Start + 14 < CurTime() then
        local t = ((CurTime() - (wT.AJS.Start + 14))) 
        opacity = Lerp(t, 255, 0)
    end

    local scrw = ScrW()
    local scrh = ScrH()

    draw.SimpleTextOutlined(string.format("poważny użytkownik %s wszedł na serwer.", wT.AJS.Admin:Name()), "DermaDefault", 16, scrh * 0.65, Color(0,255,255,opacity), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0,0,0,opacity))
end

function wT.AJS.LocalPlayer()
    if !table.HasValue(wT.AJS.Config.GroupsPlayback, LocalPlayer():GetUserGroup()) and !table.HasValue(wT.AJS.Config.AllowedUsers, LocalPlayer():SteamID()) then return end
    wT.AJS.Admin = LocalPlayer()
    wT.AJS.Start = CurTime()

    local snd = wT.AJS.Config.DefaultSounds[math.random(1, #wT.AJS.Config.DefaultSounds)]
    if wT.AJS.Config.Sounds[wT.AJS.Admin:SteamID()] then snd = wT.AJS.Config.Sounds[wT.AJS.Admin:SteamID()] end

    sound.PlayURL(snd, "noblock", function(snd)
        if IsValid(snd) then
            snd:Play()
            snd:SetVolume(0.5)
        end
    end)
    wT.Print(string.format("poważny użytkownik %s wszedł na serwer.", wT.AJS.Admin:Name()), true)
end

function wT.AJS.PlayerConnect()
    wT.AJS.Admin = net.ReadEntity()
    if !IsValid(wT.AJS.Admin) then return end
    wT.AJS.Start = CurTime()

    local snd = wT.AJS.Config.DefaultSounds[math.random(1, #wT.AJS.Config.DefaultSounds)]
    if wT.AJS.Config.Sounds[wT.AJS.Admin:SteamID()] then snd = wT.AJS.Config.Sounds[wT.AJS.Admin:SteamID()] end

    sound.PlayURL(snd, "noblock", function(snd)
        if IsValid(snd) then
            snd:Play()
            snd:SetVolume(0.5)
        end
    end)
    wT.Print(string.format("poważny użytkownik %s wszedł na serwer.", wT.AJS.Admin:Name()), true)
end
net.Receive("wT.AJS::AdminJoined", wT.AJS.PlayerConnect)
hook.Add("InitPostEntity", "wT.AJS.LocalPlayer", wT.AJS.LocalPlayer)
hook.Add("HUDPaint", "wT.AJS.Draw", wT.AJS.Draw)