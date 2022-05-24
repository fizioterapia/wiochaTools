local plyMeta = FindMetaTable("Player")

function plyMeta:GetTokens()
    if !IsValid(self) then return end
    return self:GetNWInt("WTokens", self:GetPData("WTokens") or 0)
end

function plyMeta:Pay(player, amount)
    if !IsValid(self) or !IsValid(player) then self:wText("Nie ma takiego użytkownika na serwerze.") return false end
    if player == self then self:wText("Nie możesz wysłać tokenów do samego siebie.") return false end
    if self:GetTokens() < amount then self:wText("Nie masz wystarczająco tokenów.") return false end

    player:AddTokens(amount)
    self:AddTokens(-amount)

    self:wText(string.format("Przekazałeś %s %d tokenów.", player:Name(), amount))
    player:wText(string.format("Otrzymałeś %d tokenów od %s.", amount, self:Name()))

    return true
end

function plyMeta:SetTokens(amount)
    if !IsValid(self) then return end

    amount = tonumber(amount)
    self:SetNWInt("WTokens", amount)
    self:SetPData("WTokens", self:GetTokens())
end

function plyMeta:AddTokens(amount)
    if !IsValid(self) then return end

    self:SetTokens(self:GetTokens() + amount)

    if amount > 0 then
        self:wText(string.format("Otrzymałeś %d tokenów.", amount))
    else
        self:wText(string.format("Straciłeś %d tokenów.", amount))
    end
end

function wT.SaveTokens(ply)
    // just to be safe
    ply:SetPData("WTokens", ply:GetTokens())
end

function wT.LoadTokens(ply)
    local tokens = ply:GetPData("WTokens")
    ply:SetTokens(tokens)
end

if SERVER then
    wT.PayCmds = {
        "!pay",
        "!paytokens",
        "!zaplac",
        "!zaplactokeny",
        "!givetokens"
    }
    function wT.Pay(ply, text, team)
        txt = string.Split(text, " ")
        if (#txt >= 3 and table.HasValue(wT.PayCmds, txt[1])) then
            local amount = tonumber(txt[3])
            local receiver

            for k,v in ipairs(player.GetAll()) do
                if !IsValid(v) then continue end
                if string.match(v:Name(), txt[2]) then receiver = v end
            end

            ply:Pay(receiver, amount)
        end
    end
end
hook.Add("PlayerSay", "wT::TypingGame", wT.Pay)
hook.Add("PlayerDisconnected", "wiochaTools::SaveMoney", wT.SaveTokens)
hook.Add("PlayerInitialSpawn", "wiochaTools::LoadMoney", wT.LoadTokens)