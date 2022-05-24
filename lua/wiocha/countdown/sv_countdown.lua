/*
function wT.SetupCountdown(len)
    local data = net.ReadInt(16)
    local title = net.ReadString()

    wT.CountdownActive = true
    wT.CountdownDuration = duration
    wT.CountdownFrom = CurTime()
    wT.CountdownTo = CurTime() + wT.CountdownDuration
    wT.CountdownTitle = title
end

net.Receive("wiochaTools_Countdown", wT.SetupCountdown)
*/

util.AddNetworkString("wiochaTools_Countdown")

wT.CountdownActive = false
wT.CountdownFrom = 0
wT.CountdownTo = 0
wT.CountdownDuration = 0
wT.CountdownTitle = ""

function wT:SetCountdown(title, duration, audio)
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

function wT.CheckCountdown(len, ply)
    if !wT.CountdownActive or (wT.CountdownTo - CurTime() < 0) then wT.CountdownActive = false return end

    net.Start("wiochaTools_Countdown")
        net.WriteInt(wT.CountdownTo - CurTime(), 16)
        net.WriteString(wT.CountdownTitle)
        net.WriteString(wT.CountdownAudio)
    net.Broadcast()
end
net.Receive("wiochaTools_Countdown", wT.CheckCountdown)