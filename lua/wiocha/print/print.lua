if SERVER then
    util.AddNetworkString("WiochaTools_Print")

    local plyMeta = FindMetaTable("Player")

    function plyMeta:wConsole(str)
        net.Start("WiochaTools_Print")
            net.WriteString(str)
            net.WriteBool(false)
        net.Send(self)
    end

    function plyMeta:wText(str)
        net.Start("WiochaTools_Print")
            net.WriteString(str)
            net.WriteBool(true)
        net.Send(self)
    end

    function wT:Broadcast(str)
        net.Start("WiochaTools_Print")
            net.WriteString(str)
            net.WriteBool(true)
        net.Broadcast()
    end
else
    function wT.ReadMsg(len)
        local str = net.ReadString()
        local msgType = net.ReadBool()

        if msgType then
            chat.AddText(
                Color(62,87,201),
                "[WiochaTools] ",
                Color(255,255,255),
                str
            )
        else
            MsgC(
                Color(62,87,201),
                "[WiochaTools] ",
                Color(255,255,255),
                str,
                "\n"
            )
        end
    end

    net.Receive("WiochaTools_Print", wT.ReadMsg)
end