util.AddNetworkString("wiochaTools_Countdown")

wT.CountdownActive = false
wT.CountdownFrom = 0
wT.CountdownTo = 0
wT.CountdownDuration = 0
wT.CountdownTitle = ""

function wT:SetCountdown(title, duration, audio)
    if wT.CountdownActive and wT.CountdownTo > CurTime() then return end

    wT.CountdownActive = true
    wT.CountdownTitle = title
    wT.CountdownDuration = duration
    wT.CountdownFrom = CurTime()
    wT.CountdownTo = CurTime() + wT.CountdownDuration
    wT.CountdownAudio = audio or ""

    net.Start("wiochaTools_Countdown")
        net.WriteInt(wT.CountdownDuration, 16)
        net.WriteString(wT.CountdownTitle)
        net.WriteString(wT.CountdownAudio)
    net.Broadcast()
end

function wT:StopCountdown()
    net.Start("wiochaTools_Countdown")
        net.WriteInt(0, 16)
        net.WriteString("")
        net.WriteString("")
    net.Broadcast()

    wT.CountdownActive = false
end

function wT.CheckCountdown(len, ply)
    if !wT.CountdownActive or (wT.CountdownTo - CurTime() < 0) then wT.CountdownActive = false return end

    net.Start("wiochaTools_Countdown")
        net.WriteInt(wT.CountdownTo - CurTime(), 16)
        net.WriteString(wT.CountdownTitle)
        net.WriteString(wT.CountdownAudio)
    net.Broadcast()
end
net.Receive("wiochaTools_Countdown", wT.CheckCountdown)