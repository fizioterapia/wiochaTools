local plyMeta = FindMetaTable("Player")

function plyMeta:GetTokens()
    if !IsValid(self) then return end
    return self:GetNWInt("WTokens", 0)
end

function plyMeta:Pay(player, amount)
    if !IsValid(self) or !IsValid(player) then return end
    if self:GetTokens() < amount then return end

    player:AddTokens(amount)
    self:AddTokens(-amount)

    self:wText(string.format("Przekazałeś %s %d tokenów.", player:Name(), amount))
    player:wText(string.format("Otrzymałeś %d tokenów od %s.", amount, self:Name()))
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
    self:SetPData("WTokens", self:GetTokens())

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
    ply:SetTokens("WTokens", ply:GetPData("WTokens"))
end

hook.Add("PlayerDisconnected", "wiochaTools::SaveMoney", wT.SaveTokens)
hook.Add("PlayerInitialSpawn", "wiochaTools::LoadMoney", wT.LoadTokens)