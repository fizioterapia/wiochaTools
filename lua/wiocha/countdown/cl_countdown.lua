wT.CountdownBar = {
    w = ScrW() / 3,
    h = 24
}

wT.CountdownActive = false
wT.CountdownDuration = 0
wT.CountdownFrom = CurTime()
wT.CountdownTo = CurTime()
wT.CountdownTitle = ""

function wT.DrawCountdown()
    if !wT.CountdownActive or (wT.CountdownTo - CurTime() < 0) then 
        wT.CountdownActive = false
        if wT.CountdownSound and IsValid(wT.CountdownSound) then 
            wT.CountdownSound:Stop()
            wT.CountdownSound = nil
        end
        return 
    end

    local progress = 1 - (wT.CountdownTo - CurTime()) / wT.CountdownDuration

    local scrw = ScrW()
    local scrh = ScrH()

    local txt = wT.CountdownTitle .. " (" .. math.ceil(wT.CountdownTo - CurTime()) .. " s)"

    local textsize = wHUD.TextSize(txt, "wHUD.Font")
    wHUD.Text(txt, "wHUD.Font", scrw / 2 - textsize.w / 2, scrh / 2 - textsize.h / 2 - wT.CountdownBar.h - 8, wHUD.c.white, wHUD.c.black)
    wHUD.Box(scrw / 2 - wT.CountdownBar.w / 2, scrh / 2 - wT.CountdownBar.h / 2, wT.CountdownBar.w, wT.CountdownBar.h, Color(0,0,0))
    surface.SetDrawColor(255,255,255)
    surface.DrawRect(scrw / 2 - wT.CountdownBar.w / 2 + 4, scrh / 2 - wT.CountdownBar.h / 2 + 4, (wT.CountdownBar.w - 8) * progress, wT.CountdownBar.h - 7)
end
hook.Add("HUDPaint", "wT::DrawCountdown", wT.DrawCountdown)

function wT.SetupCountdown(len)
    local duration = net.ReadInt(16)
    local title = net.ReadString()
    local audio = net.ReadString()

    wT.CountdownActive = true
    wT.CountdownDuration = duration
    wT.CountdownFrom = CurTime()
    wT.CountdownTo = CurTime() + wT.CountdownDuration
    wT.CountdownTitle = title

    if audio then
        sound.PlayURL(audio, "noblock", function(snd)
            if IsValid(snd) then
                wT.CountdownSound = snd
                wT.CountdownSound:Play()
            end
        end)
    end
end

net.Receive("wiochaTools_Countdown", wT.SetupCountdown)
hook.Add("InitPostEntity", "wiochaTools::CheckCountdown", function()
    net.Start("wiochaTools_Countdown")
    net.SendToServer()
end)