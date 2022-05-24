wT.Minigames = {
    [1] = {
        name = "math quiz",
        game = function()
            local num1 = math.random(1,99)
            local num2 = math.random(1,99)
            local operators = {'+', '-', '*'}
            local operator = operators[math.random(1,#operators)]
            local operation = string.format('%d%s%d', num1, operator, num2)
            local result = CompileString("return (" .. operation .. ")")
            local tokenValue = math.random(20,50)
            result = result()

            hook.Add("PlayerSay", "wT::MathQuiz", function(ply, txt)
                if txt == tostring(result) then
                    wT.MinigameInProgress = false
                    wT:Broadcast(string.format("%s na chuj ty to obliczałeś (+%d wTokens).", ply:Name(), tokenValue))
                    ply:AddTokens(tokenValue)
                    
                    hook.Remove("PlayerSay", "wT::MathQuiz")
                    return ""
                end
            end)

            wT:Broadcast(string.format("Oblicz: %s (+%d wT)", operation, tokenValue))
        end,
        timeOut = function()
            wT:Broadcast("Nikt tego nie obliczył, debile pojebane.")
            hook.Remove("PlayerSay", "wT::MathQuiz")
        end
    },
    [2] = {
        name = "typing game",
        game = function()
            local text = {}
            for i = 1, math.random(8,16) do
                // 65->90 97->122
                if math.random(0,3) % 2 == 0 then
                    text[i] = string.char( math.random(65, 90) )
                else
                    text[i] = string.char( math.random(97, 122) )
                end
            end
            text = table.concat(text, "")
            local tokenValue = math.random(20,50)

            hook.Add("PlayerSay", "wT::TypingGame", function(ply, txt)
                if txt == string.Replace(text, " ", "") then
                    wT.MinigameInProgress = false
                    wT:Broadcast(string.format("%s na chuj ty to pisałeś (+%d wTokens).", ply:Name(), tokenValue))
                    ply:AddTokens(tokenValue)
                    
                    hook.Remove("PlayerSay", "wT::TypingGame")
                    return ""
                end
            end)

            wT:Broadcast(string.format("Przepisz: %s (+%d wT)", text, tokenValue))
        end,
        timeOut = function()
            wT:Broadcast("Nikt tego nie przepisał, debile pojebane.")
            hook.Remove("PlayerSay", "wT::TypingGame")
        end
    }
}

wT.MinigameInProgress = false
wT.MinigameDuration = 120

function wT.RandomMinigame()
    if wT.MinigameInProgress then return end

    wT.Minigame = wT.Minigames[math.random(1,#wT.Minigames)]
    wT.Minigame.game()
    wT.MinigameInProgress = true

    timer.Simple(wT.MinigameDuration, wT.TimesOut)
end

function wT.TimesOut()
    if wT.MinigameInProgress == false then return end

    wT.MinigameInProgress = false
    wT.Minigame.timeOut()
    wT.Minigame = nil
end
timer.Create("MinigameTimer", 600, 0, wT.RandomMinigame)