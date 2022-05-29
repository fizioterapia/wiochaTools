wT.Motd = wT.Motd or {}

surface.CreateFont("wT.Motd.Header", {
    size = 32,
    font = "Tahoma Bold",
    weight = "600",
    extended = true,
    antialias = true
})

wT.Motd.Website = [[
    <meta charset="utf-8" />
    <style>
        body, html {
            margin: 0px;
            background-color: black;

            font-family: 'Tahoma', sans-serif;
            color: rgb(230,176,73);
        }

        #motd {
            text-align: center;
            position: absolute;
            top: 50%;
            left: 50%;

            -webkit-transform: translate(-50%,-50%);
            transform: translate(-50%,-50%);
        }

        h1, p {
            margin: 8px 0;
        }

        .links a {
            display: inline-block;
            margin: 16px;
            padding: 16px 32px;

            text-decoration: none;
            border: 2px solid rgb(230,176,73);
            color: rgb(230,176,73);
        }

        a:hover {
            border: 2px solid rgb(240,186,83);
            color: rgb(255,255,255);
        }
    </style>
    <div id="motd">
        <h1>wiochaBOX</h1>
        <p>największa wiocha w Polsce</p>

        <div class="links">
            <a href="https://steamcommunity.com/sharedfiles/filedetails/?id=1525758979">Paczka</a>
            <a href="https://discord.gg/NmMggRRewY">Discord</a>
        </div>
    </div>
]]

function wT.Motd:Create()
    if wT.Motd.Instance and wT.Motd.Instance:IsValid() then wT.Motd.Instance:Remove() end
    
    wT.Motd.Instance = vgui.Create("DFrame")
    wT.Motd.Instance:SetSize(ScrW() * 0.75, ScrH() * 0.75)
    wT.Motd.Instance:SetTitle("")
    wT.Motd.Instance:ShowCloseButton(false)
    wT.Motd.Instance:Center()
    wT.Motd.Instance:MakePopup()
    function wT.Motd.Instance:Paint() end

    wT.Motd.Instance.Header = vgui.Create("DPanel", wT.Motd.Instance)
    wT.Motd.Instance.Header:Dock(TOP)
    wT.Motd.Instance.Header:DockMargin(0,0,0,2)
    wT.Motd.Instance.Header:SetTall(84)
    wT.Motd.Instance.Header:DockPadding(16,16,16,16)
    function wT.Motd.Instance.Header:Paint(w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, Color(0,0,0,225), true, true, false, false)
    end

    wT.Motd.Instance.Header.Icon = vgui.Create("DLabel", wT.Motd.Instance.Header)
    wT.Motd.Instance.Header.Icon:SetColor(Color(230,176,73))
    wT.Motd.Instance.Header.Icon:SetFont("HL2MPTypeDeath")
    wT.Motd.Instance.Header.Icon:SetText("A")
    wT.Motd.Instance.Header.Icon:SizeToContents()
    wT.Motd.Instance.Header.Icon:Dock(LEFT)

    wT.Motd.Instance.Header.Label = vgui.Create("DLabel", wT.Motd.Instance.Header)
    wT.Motd.Instance.Header.Label:SetColor(Color(230,176,73))
    wT.Motd.Instance.Header.Label:SetFont("wT.Motd.Header")
    wT.Motd.Instance.Header.Label:SetText("wiochaBox")
    wT.Motd.Instance.Header.Label:SizeToContents()
    wT.Motd.Instance.Header.Label:Dock(LEFT)

    wT.Motd.Instance.Container = vgui.Create("DPanel", wT.Motd.Instance)
    wT.Motd.Instance.Container:Dock(FILL)
    wT.Motd.Instance.Container:DockPadding(36,36,36,36)
    wT.Motd.Instance.Container:InvalidateParent(true)
    function wT.Motd.Instance.Container:Paint(w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, Color(0,0,0,225), false, false, true, true)
    end

    wT.Motd.Instance.Container.Website = vgui.Create("DHTML", wT.Motd.Instance.Container)
    wT.Motd.Instance.Container.Website:Dock(TOP)
    wT.Motd.Instance.Container.Website:DockMargin(0,0,0,16)
    wT.Motd.Instance.Container.Website:SetTall(wT.Motd.Instance.Container:GetTall() - (72 + 16 + 16 + 24))
    wT.Motd.Instance.Container.Website:SetHTML(wT.Motd.Website)

    wT.Motd.Instance.Container.CloseButton = vgui.Create("DButton", wT.Motd.Instance.Container)
    wT.Motd.Instance.Container.CloseButton:Dock(LEFT)
    wT.Motd.Instance.Container.CloseButton:SetText("")
    wT.Motd.Instance.Container.CloseButton:SetWide(96)
    function wT.Motd.Instance.Container.CloseButton:Paint(w, h)
        surface.SetDrawColor(0,0,0,100)
        surface.DrawRect(0,0,w,h)

        surface.SetDrawColor(230,176,73)
        surface.DrawRect(0,0,w,1)
        surface.DrawRect(0,0,1,h)
        surface.DrawRect(0,h-1,w,1)
        surface.DrawRect(w-1,0,1,h)

        draw.SimpleText("OK", "DermaDefault", w / 2, h / 2, Color(230,176,73), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    function wT.Motd.Instance.Container.CloseButton:DoClick()
        if wT.Motd.Instance:IsValid() then
            wT.Motd.Instance:Close()
        end
    end
end

wT.Motd:Create()