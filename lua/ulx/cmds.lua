function wT.ULXCmds()
    local function playerSend( from, to, force )
        if not to:IsInWorld() and not force then return false end -- No way we can do this one
    
        local yawForward = to:EyeAngles().yaw
        local directions = { -- Directions to try
            math.NormalizeAngle( yawForward - 180 ), -- Behind first
            math.NormalizeAngle( yawForward + 90 ), -- Right
            math.NormalizeAngle( yawForward - 90 ), -- Left
            yawForward,
        }
    
        local t = {}
        t.start = to:GetPos() + Vector( 0, 0, 32 ) -- Move them up a bit so they can travel across the ground
        t.filter = { to, from }
    
        local i = 1
        t.endpos = to:GetPos() + Angle( 0, directions[ i ], 0 ):Forward() * 47 -- (33 is player width, this is sqrt( 33^2 * 2 ))
        local tr = util.TraceEntity( t, from )
        while tr.Hit do -- While it's hitting something, check other angles
            i = i + 1
            if i > #directions then	 -- No place found
                if force then
                    from.ulx_prevpos = from:GetPos()
                    from.ulx_prevang = from:EyeAngles()
                    return to:GetPos() + Angle( 0, directions[ 1 ], 0 ):Forward() * 47
                else
                    return false
                end
            end
    
            t.endpos = to:GetPos() + Angle( 0, directions[ i ], 0 ):Forward() * 47
    
            tr = util.TraceEntity( t, from )
        end
    
        from.ulx_prevpos = from:GetPos()
        from.ulx_prevang = from:EyeAngles()
        return tr.HitPos
    end

    function wT.sgoto( calling_ply, target_ply )
        if not calling_ply:IsValid() then
            Msg( "You may not step down into the mortal world from console.\n" )
            return
        end
    
        if ulx.getExclusive( calling_ply, calling_ply ) then
            ULib.tsayError( calling_ply, ulx.getExclusive( calling_ply, calling_ply ), true )
            return
        end
    
        if not target_ply:Alive() then
            ULib.tsayError( calling_ply, target_ply:Nick() .. " is dead!", true )
            return
        end
    
        if not calling_ply:Alive() then
            ULib.tsayError( calling_ply, "You are dead!", true )
            return
        end
    
        if target_ply:InVehicle() and calling_ply:GetMoveType() ~= MOVETYPE_NOCLIP then
            ULib.tsayError( calling_ply, "Target is in a vehicle! Noclip and use this command to force a goto.", true )
            return
        end
    
        local newpos = playerSend( calling_ply, target_ply, calling_ply:GetMoveType() == MOVETYPE_NOCLIP )
        if not newpos then
            ULib.tsayError( calling_ply, "Can't find a place to put you! Noclip and use this command to force a goto.", true )
            return
        end
    
        if calling_ply:InVehicle() then
            calling_ply:ExitVehicle()
        end
    
        local newang = (target_ply:GetPos() - newpos):Angle()
    
        calling_ply:SetPos( newpos )
        calling_ply:SetEyeAngles( newang )
        calling_ply:SetLocalVelocity( Vector( 0, 0, 0 ) ) -- Stop!
    end
    local goto = ulx.command( CATEGORY_NAME, "ulx sgoto", wT.sgoto, "!sgoto" )
    goto:addParam{ type=ULib.cmds.PlayerArg, target="!^", ULib.cmds.ignoreCanTarget }
    goto:defaultAccess( ULib.ACCESS_ADMIN )
    goto:help( "Goto target." )
end
hook.Add("ULXLoaded", "WiochaTools::AddCommands", wT.ULXCmds)