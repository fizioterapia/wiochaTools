util.AddNetworkString("wHUD_RestartTime")

wHUD = wHUD or {}

function wHUD.GetTime()
    time = os.time()
    local date = os.date("%H:%M:%S:%d:%m:%Y", time)
    date = string.Explode(":", date)

    if tonumber(date[1]) > 3 then
        time = os.time({
            day = tonumber(date[4]) + 1,
            month = tonumber(date[5]),
            year = tonumber(date[6]),
            hour = 3,
            min = 0,
            sec = 0
        })
    else
        time = os.time({
            day = tonumber(date[4]),
            month = tonumber(date[5]),
            year = tonumber(date[6]),
            hour = 3,
            min = 0,
            sec = 0
        })
    end

    return time
end

net.Receive("wHUD_RestartTime", function(len, ply)
    local time = wHUD.GetTime()

    net.Start("wHUD_RestartTime")
        net.WriteInt(time, 32)
    net.Send(ply)
end)

hook.Add("Think", "wHUD::RestartCountdown", function()
    if os.date("%H:%M:%S", os.time()) == "02:55:00" then
        wT:SetCountdown("Restart Serwera", 300, "https://fizi.pw/blossom-network/minimalistic-ls/lubudubu.mp3")
        hook.Remove("Think", "wHUD::RestartCountdown")
    end
end)