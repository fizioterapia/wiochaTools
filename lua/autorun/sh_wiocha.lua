wT = wT or {}

function wT:Include(fileName, path)
    print("[wiochaTools] - Including " .. path .. fileName)
    if string.match(fileName, "cl_") then
        if CLIENT then
            include(path .. fileName)
        else
            AddCSLuaFile(path .. fileName)
        end
    elseif string.match(fileName, "sv_") then
        if SERVER then
            include(path .. fileName)
        end
    else
        if CLIENT then
            include(path .. fileName)
        else
            include(path .. fileName)
            AddCSLuaFile(path .. fileName)
        end
    end
end

function wT:Search(dir)
    local f, d = file.Find(dir .. "*", "LUA")

    for _,filename in ipairs(f) do
        wT:Include(filename, dir)
    end

    for _,dirname in ipairs(d) do
        wT:Search(dir .. dirname .. "/")
    end
end

hook.Add("InitPostEntity", function()
	wT:Search("wiocha/")
end)