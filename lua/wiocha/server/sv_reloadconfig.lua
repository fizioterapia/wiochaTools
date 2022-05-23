local function reloadConfig()
    game.ConsoleCommand("reloadconfig\n")
end
hook.Add("InitPostEntity", "wiochaTools::ReloadConfig", reloadConfig)