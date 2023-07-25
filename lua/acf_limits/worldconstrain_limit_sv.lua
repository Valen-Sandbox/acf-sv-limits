local cvarFlags = { FCVAR_ARCHIVE, FCVAR_REPLICATED }
local weldCvar = CreateConVar( "acf_limits_worldconstrain", 1, cvarFlags, "Removes the ability to weld/ballsocket contraptions to the world if enabled.", 0, 1 )

-- I don't like overriding the functions for this, but I can't find a better way to do it.
hook.Add( "Initialize", "ACF_Limits_WorldWeld", function()
    timer.Simple( 0, function()
        local constraint_Weld = constraint.Weld
        local constraint_Ballsocket = constraint.Ballsocket
        local constraint_AdvBallsocket = constraint.AdvBallsocket

        function constraint.Weld( ent1, ent2, bone1, bone2, forceLimit, noCollide, deleteOnBreak )
            if weldCvar:GetBool() and ( ent1:GetContraption() or ent2:GetContraption() ) and ( ent1:IsWorld() or ent2:IsWorld() ) then return end

            return constraint_Weld( ent1, ent2, bone1, bone2, forceLimit, noCollide, deleteOnBreak )
        end

        function constraint.Ballsocket( ent1, ent2, bone1, bone2, localPos, forceLimit, torqueLimit, noCollide )
            if weldCvar:GetBool() and ( ent1:GetContraption() or ent2:GetContraption() ) and ( ent1:IsWorld() or ent2:IsWorld() ) then return end

            return constraint_Ballsocket( ent1, ent2, bone1, bone2, localPos, forceLimit, torqueLimit, noCollide )
        end

        function constraint.AdvBallsocket( ent1, ent2, bone1, bone2, lPos1, lPos2, forceLimit, torqueLimit, xMin, yMin, zMin, xMax, yMax, zMax, xFric, yFric, zFric, onlyRotation, noCollide )
            if weldCvar:GetBool() and ( ent1:GetContraption() or ent2:GetContraption() ) and ( ent1:IsWorld() or ent2:IsWorld() ) then return end

            return constraint_AdvBallsocket( ent1, ent2, bone1, bone2, lPos1, lPos2, forceLimit, torqueLimit, xMin, yMin, zMin, xMax, yMax, zMax, xFric, yFric, zFric, onlyRotation, noCollide )
        end
    end )

    hook.Remove( "Initialize", "ACF_Limits_WorldWeld" )
end )