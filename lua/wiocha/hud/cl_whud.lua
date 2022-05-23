wHUD = {}

surface.CreateFont("wHUD.Font.Player", {
    font = "Inter",
    size = 48,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont("wHUD.Font.Player.Small", {
    font = "Inter",
    size = 32,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont("wHUD.Font", {
	font = "Inter",
    size = 24,
    weight = 500,
    extended = true,
    antialias = true
})

surface.CreateFont("wHUD.Font.Small", {
	font = "Inter",
    size = 18,
    weight = 500,
    extended = true,
    antialias = true
})

wHUD.c = {
    ["white"] = Color(255, 255, 255),
    ["black"] = Color(0, 0, 0),
    ["blacka"] = Color(0, 0, 0, 200),
    ["blue"] = Color(73, 106, 255),
    ["red"] = Color(255, 73, 73)
}

local lp = LocalPlayer()

-- drawing functions
function wHUD.Text(txt, font, x, y, col, outlinecol)
    if outlinecol then
        draw.SimpleTextOutlined(txt, font, x, y, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, outlinecol)
    else
        draw.SimpleText(txt, font, x, y, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
end

function wHUD.Box(x, y, w, h, col)
    surface.SetDrawColor(col)
    surface.DrawRect(x, y, w, h)

	surface.SetDrawColor(wHUD.c.white)
	surface.DrawRect(x, y, 1, h)
	surface.DrawRect(x, y, w, 1)
	surface.DrawRect(x + w, y, 1, h)
	surface.DrawRect(x, y + h, w, 1)
end

function wHUD.TextSize(txt, font)
    surface.SetFont(font)
    local w, h = surface.GetTextSize(txt)

    return {
        ["w"] = w,
        ["h"] = h
    }
end

-- adverts

wHUD.AdvertsTbl = {
	{
		title = "Discord",
		content = "https://discord.gg/NmMggRRewY",
		col = Color(88, 101, 242)
	},
	{
		title = "Build-Mode",
		content = "Napisz !build aby włączyć build-mode lub !pvp aby zacząć się zabijać.",
		col = Color(39,133,209)
	},
    {
        title = "Bhop?",
        content = "Wpisz 'auto_bhop 1' w konsoli!",
        col = Color(88, 242, 109)
    }
}
wHUD.Advert = {}
wHUD.LastAdvert = 0
wHUD.SoundsTbl = {
	"garrysmod/content_downloaded.wav",
	"garrysmod/garrysmod/ui_click.wav",
	"garrysmod/balloon_pop_cute.wav"
}

function wHUD.AdvertLogic()
	if #wHUD.AdvertsTbl <= wHUD.LastAdvert then
		wHUD.LastAdvert = 1
	else
		wHUD.LastAdvert = wHUD.LastAdvert + 1
	end

	wHUD.Advert = wHUD.AdvertsTbl[wHUD.LastAdvert]
	timer.Simple(15, function()
		wHUD.Advert = {}
	end)
	surface.PlaySound(wHUD.SoundsTbl[math.random(1, #wHUD.SoundsTbl)])
	chat.AddText(wHUD.Advert.col, "[", string.upper(wHUD.Advert.title), "] ",  Color(255,255,255), wHUD.Advert.content)
end
timer.Create("wHUD.AdvertLogic", 300, 0, wHUD.AdvertLogic)

function wHUD.Adverts()

	if wHUD.Advert and wHUD.Advert.title and wHUD.Advert.content then
		local boxsize = wHUD.TextSize(wHUD.Advert.content, "wHUD.Font.Small")
		wHUD.Box(8, 104, boxsize.w + 32, 64, wHUD.c.blacka)
		wHUD.Text(wHUD.Advert.title, "wHUD.Font", 16, 112, wHUD.Advert.col, wHUD.c.black)
		wHUD.Text(wHUD.Advert.content, "wHUD.Font.Small", 16, 136, wHUD.c.white, wHUD.c.black)
	end
end

-- hooks
-- 2d
function wHUD.DrawAmmo()
    local wep = lp:GetActiveWeapon()
    if !IsValid(wep) then return false end

    local wepText = string.upper(wep:GetPrintName())
    local wepAmmo = -1
    local wepSecondary = -1

    wepAmmo = wep:Clip1()
    wepSecondary = lp:GetAmmoCount( wep:GetPrimaryAmmoType() )

    surface.SetFont("wHUD.Font")
    local ww, wh = surface.GetTextSize(wepText)
    surface.SetFont("wHUD.Font.Player")
    local ww2, wh2 = surface.GetTextSize(wepAmmo .. " / " .. wepSecondary)
    if ww2 > ww then ww = ww2 end
    ww = ww + 64

    surface.SetDrawColor( 0, 0, 0, 100 )
    if wepAmmo > -1 and wepSecondary > -1 then
        wHUD.AmmoSize = 64
        surface.DrawRect(ScrW() - ww - 8, ScrH() - 72, ww, 24)
        surface.DrawRect(ScrW() - ww - 8, ScrH() - 72, ww, 64)
    else
        wHUD.AmmoSize = 24
        surface.DrawRect(ScrW() - ww - 8, ScrH() - 32, ww, 24)
        surface.DrawRect(ScrW() - ww - 8, ScrH() - 32, ww, 24)
    end

    surface.SetDrawColor(255, 255, 255, 50)
    if wepAmmo > -1 and wepSecondary > -1 then
        surface.DrawRect(ScrW() - ww - 9, ScrH() - 73, ww, 1)
        surface.DrawRect(ScrW() - ww - 9, ScrH() - 48, ww, 1)
        surface.DrawRect(ScrW() - ww - 9, ScrH() - 72, 1, 64)
        surface.DrawRect(ScrW() - 9, ScrH() - 73, 1, 64)
        surface.DrawRect(ScrW() - ww - 9, ScrH() - 9, ww + 1, 1)
    else
        surface.DrawRect(ScrW() - ww - 9, ScrH() - 33, ww, 1)
        surface.DrawRect(ScrW() - ww - 9, ScrH() - 8, ww, 1)
        surface.DrawRect(ScrW() - ww - 9, ScrH() - 32, 1, 24)
        surface.DrawRect(ScrW() - 9, ScrH() - 33, 1, 24)
    end

    if wepAmmo > -1 and wepSecondary > -1 then
        draw.SimpleTextOutlined(wepText, "wHUD.Font", ScrW() - ww / 2 - 9, ScrH() - 74, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0))
        draw.SimpleTextOutlined(wepAmmo .. " / " .. wepSecondary, "wHUD.Font.Player", ScrW() - ww / 2 - 9, ScrH() - 52, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0))
    else
        draw.SimpleTextOutlined(wepText, "wHUD.Font", ScrW() - ww / 2 - 9, ScrH() - 34, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0))
    end
end

function wHUD.Restart()
    local time = wHUD.RestartTime or os.time()
    local seconds = time - os.time()
    local minutes = math.floor(seconds / 60)
    seconds = seconds - minutes * 60
    local hours = math.floor(minutes / 60)
    minutes = minutes - (hours * 60)

    if seconds < 10 then
        seconds = "0" .. seconds
    end

    if minutes < 10 then
        minutes = "0" .. minutes
    end

    if hours < 10 then
        hours = "0" .. hours
    end

    draw.SimpleTextOutlined(string.format("restart in: %s:%s:%s (pl time)", hours, minutes, seconds), "wHUD.Font", ScrW() / 2, 16, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, wHUD.c.black)

end

function wHUD.Draw()
    if !IsValid(lp) then lp = LocalPlayer() end

    local scrw = ScrW()
    local scrh = ScrH()
    local velocity = lp:GetVelocity()
    velocity = velocity:Length()

    wHUD.Text("wiochaHUD", "wHUD.Font", 8, 8, HSVToColor((CurTime() * 5) % 360, 1, 1), wHUD.c.black)
    if lp:GetNWBool("_Kyle_Buildmode") then
        wHUD.Text("Build Mode", "wHUD.Font.Small", 8, 32, wHUD.c.blue, wHUD.c.black)
    else
        wHUD.Text("PVP Mode", "wHUD.Font.Small", 8, 32, wHUD.c.red, wHUD.c.black)
    end
    wHUD.Text("alpha - 0.1.1", "wHUD.Font.Small", 8, 46, wHUD.c.white, wHUD.c.black)
    wHUD.Text("#makelovenotwar", "wHUD.Font.Small", 8, 60, wHUD.c.white, wHUD.c.black)
    wHUD.Text(string.format("velocity: %d", velocity), "wHUD.Font.Small", 8, 74, wHUD.c.white, wHUD.c.black)

	-- ammo
	wHUD.DrawAmmo()
	-- adverts
	wHUD.Adverts()
    -- ent info
    wHUD.DrawEnt()
    -- player info	
    local boxsize = wHUD.TextSize(lp:Name(), "wHUD.Font")
    wHUD.Box(8, scrh - 72, math.max(200, boxsize.w + 16), 64, wHUD.c.blacka)
    wHUD.Text(lp:Name(), "wHUD.Font", 16, scrh - 68, team.GetColor(LocalPlayer():Team()) or wHUD.c.white, wHUD.c.black)
    wHUD.Text(string.format("HEALTH: %d", lp:Health()), "wHUD.Font.Small", 16, scrh - 42, wHUD.c.white, wHUD.c.black)
    wHUD.Text(string.format("ARMOR: %d", lp:Armor()), "wHUD.Font.Small", 16, scrh - 30, wHUD.c.white, wHUD.c.black)
    -- restart
    wHUD.Restart()
end

-- 3d2d
function wHUD.DrawEnt()
    local ent = lp:GetEyeTrace().Entity

    if IsValid(ent) and not ent:IsPlayer() then
        local scrh = ScrH()
        local owner = ""

        if IsValid(ent:CPPIGetOwner()) then
            owner = ent:CPPIGetOwner():Name()
        else
            owner = "NULL"
        end

        local output = ""
        output = output .. "CLASS: " .. ent:GetClass() .. "\n"
        output = output .. "MODEL: " .. ent:GetModel() .. "\n"
        output = output .. "OWNER: " .. owner .. "\n"
        output = output .. "POS: " .. string.format("Vector(%f, %f, %f)", ent:GetPos().x, ent:GetPos().y, ent:GetPos().z) .. "\n"
        output = output .. "ANG: " .. string.format("Angle(%f, %f, %f)", ent:GetAngles().pitch, ent:GetAngles().yaw, ent:GetAngles().roll) .. "\n"
		output = output .. "GRAVITY: " .. ent:GetGravity()
        

        local boxsize = wHUD.TextSize(output, "wHUD.Font.Small")
        wHUD.Box(8, (scrh / 2) - boxsize.h / 2 - 8, boxsize.w + 16, boxsize.h + 16, wHUD.c.blacka)
        draw.DrawText(output, "wHUD.Font.Small", 16, (scrh / 2) - (boxsize.h / 2), wHUD.c.white)
    end
end

function wHUD.Player(ply)
    local pos = ply:EyePos() or ply:GetPos()
    pos.z = pos.z + 36

    if ply:Crouching() then
        pos.z = pos.z + 18
    end

    local angles = (Vector(lp:GetPos().x, lp:GetPos().y, 0) - Vector(ply:GetPos().x, ply:GetPos().y, 0)):Angle() + Angle(0, 90, 90)
    local name, color = hook.Call("aTag_GetScoreboardTag", nil, ply)

    if ply:IsBot() then
        name = "BOT"
        color = Color(149, 212, 76)
    end

    cam.Start3D2D(pos, angles, 0.1)
    draw.SimpleTextOutlined(ply:Name(), "wHUD.Font.Player", 0, 156, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
    draw.SimpleTextOutlined(name, "wHUD.Font.Player.Small", 0, 200, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
    draw.SimpleTextOutlined(ply:Health() .. " HP", "wHUD.Font.Player.Small", 0, 232, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

    if ply:GetNWBool("_Kyle_Buildmode") then
        draw.SimpleTextOutlined("Build Mode", "wHUD.Font.Player.Small", 0, 260, wHUD.c.blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
    else
        draw.SimpleTextOutlined("PVP Mode", "wHUD.Font.Player.Small", 0, 260, wHUD.c.red, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
    end

    cam.End3D2D()
end

function wHUD.DrawPlayerInfo()
    if not lp or not IsValid(lp) then return end
    local shootPos = lp:GetShootPos()
    local aimVec = lp:GetAimVector()

    for _, ply in ipairs(player.GetAll()) do
        if not IsValid(ply) or ply == lp or not ply:Alive() or ply:GetNoDraw() or ply:IsDormant() then continue end
        local hisPos = ply:GetShootPos()

        if hisPos:DistToSqr(shootPos) < 100000 then
            local pos = hisPos - shootPos
            local unitPos = pos:GetNormalized()

            if unitPos:Dot(aimVec) > 0.775 then
                local trace = util.QuickTrace(shootPos, pos, lp)

                if trace.Hit and trace.Entity ~= ply then
                    if trace.Entity:IsPlayer() then
                        wHUD.Player(trace.Entity)
                    end

                    break
                end

                wHUD.Player(ply)
            end
        end
    end
end


local hide = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
	["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true
}

hook.Add("HUDShouldDraw", "HideHUD", function(name)
    if hide[name] then return false end
end)
hook.Add("HUDDrawTargetID", "HideHUD", function() return false end)
hook.Add("PostDrawTranslucentRenderables", "wHUD.DrawPlayerInfo", wHUD.DrawPlayerInfo)
hook.Add("HUDPaint", "wHUD.Draw", wHUD.Draw)
hook.Add("InitPostEntity", "wHUD::Time", function()
    net.Start("wHUD_RestartTime")
    net.SendToServer()
end)

net.Receive("wHUD_RestartTime", function(len)
    wHUD.RestartTime = net.ReadInt(32)
end)