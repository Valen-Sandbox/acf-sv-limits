local cvarFlags = { FCVAR_ARCHIVE, FCVAR_REPLICATED }
local caliberCvar = CreateConVar( "acf_limits_caliber", 5000, cvarFlags, "The maximum total ACF caliber that a player can have out at once (in mm).", 0, 5000 )

hook.Add( "PlayerInitialSpawn", "ACF_Limits_Caliber", function( ply )
    ply.CaliberTotal = 0
end )

hook.Add( "ACF_CanCreateEntity", "ACF_Limits_Caliber", function( class, ply, pos, ang, data )
    local caliberLimit = caliberCvar:GetInt()
    local entCaliber = data.Caliber

    if ply.CaliberTotal < 0 then ply.CaliberTotal = 0 end -- This value should never go below 0
    local newTotal = ply.CaliberTotal + entCaliber

    if newTotal > caliberLimit then return false, "ACF total caliber limit reached! (" .. caliberLimit .. " mm)" end

    ply.CaliberTotal = newTotal
end )

hook.Add( "ACF_CanUpdateEntity", "ACF_Limits_Caliber", function( ent, data )
    local ply = ent:GetOwner()
    local caliberLimit = caliberCvar:GetInt()
    local caliberOld = ent.Caliber
    local caliberNew = data.Caliber

    if ply.CaliberTotal < 0 then ply.CaliberTotal = 0 end -- This value should never go below 0
    local newTotal = ply.CaliberTotal + caliberNew - caliberOld

    if newTotal > caliberLimit then return false, "ACF total caliber limit reached! (" .. caliberLimit .. " mm)" end

    ply.CaliberTotal = newTotal
end )

hook.Add( "EntityRemoved", "ACF_Limits_Caliber", function( ent )
    if not IsValid( ent ) or not ent.Caliber then return end

    local ply = ent:GetOwner()
    ply.CaliberTotal = ply.CaliberTotal - ent.Caliber
end )