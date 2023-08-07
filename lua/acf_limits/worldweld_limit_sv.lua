local cvarFlags = { FCVAR_ARCHIVE, FCVAR_REPLICATED }
local weldCvar = CreateConVar( "acf_limits_worldweld", 1, cvarFlags, "Removes the ability to weld contraptions to the world if enabled.", 0, 1 )

-- I don't like overriding the weld function for this, but I can't find a better way to do it.
timer.Simple( 0, function()
    local constraint_Weld = constraint.Weld

    function constraint.Weld( ent1, ent2, bone1, bone2, forceLimit, noCollide, deleteOnBreak )
        if weldCvar:GetBool() and ( ent1:GetContraption() or ent2:GetContraption() ) and ( ent1:IsWorld() or ent2:IsWorld() ) then return end

        return constraint_Weld( ent1, ent2, bone1, bone2, forceLimit, noCollide, deleteOnBreak )
    end
end )