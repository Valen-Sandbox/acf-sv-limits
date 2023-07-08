local IsValid = IsValid

local cvarFlags = { FCVAR_ARCHIVE, FCVAR_REPLICATED }
local missileCvar = CreateConVar( "acf_limits_missiles", 18, cvarFlags, "The maximum number of missiles that a contraption may hold before its racks are disabled. Set to 0 to disable this limit.", 0 )

hook.Add( "cfw.contraption.created", "ACF_Limits_Missiles", function( con )
    if not con then return end

    con.totalMissiles = 0
end )

hook.Add( "cfw.contraption.entityAdded", "ACF_Limits_Missiles", function( con, ent )
    if missileCvar:GetInt() == 0 then return end
    if not con or not IsValid( ent ) then return end
    if ent:GetClass() ~= "acf_rack" then return end

    con.totalMissiles = con.totalMissiles + ent.MagSize
end )

hook.Add( "cfw.contraption.entityRemoved", "ACF_Limits_Missiles", function( con, ent )
    if missileCvar:GetInt() == 0 then return end
    if not con or not IsValid( ent ) then return end
    if ent:GetClass() ~= "acf_rack" then return end

    con.totalMissiles = con.totalMissiles - ent.MagSize
end )

hook.Add( "ACF_IsLegal", "ACF_Limits_Missiles", function( ent )
    local missileLimit = missileCvar:GetInt()
    if missileLimit == 0 then return end
    if ent:GetClass() ~= "acf_rack" then return end

    local con = ent:GetContraption()
    if not con then return end

    if con.totalMissiles > missileLimit then return false, "Missile Count Limited", "Your contraption would surpass the missile limit (" .. missileLimit .. " missiles) and has been disabled." end
end )