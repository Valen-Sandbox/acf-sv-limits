local IsValid = IsValid

local cvarFlags = { FCVAR_ARCHIVE, FCVAR_REPLICATED }
local missileCvar = CreateConVar( "acf_limits_missiles", 8, cvarFlags, "The maximum number of missiles that a contraption may hold before further racks are disabled. Set to 0 to disable this limit.", 0 )
local rocketCvar = CreateConVar( "acf_limits_rockets", 18, cvarFlags, "The maximum number of rockets that a contraption may hold before further racks are disabled. Set to 0 to disable this limit.", 0 )

local overLimitEnts = {}

hook.Add( "cfw.contraption.created", "ACF_Limits_Missiles", function( con )
    if not con then return end

    con.totalMissiles = 0
    con.totalRockets = 0
end )

hook.Add( "cfw.contraption.entityAdded", "ACF_Limits_Missiles", function( con, ent )
    if not con or not IsValid( ent ) then return end
    if ent:GetClass() ~= "acf_rack" then return end

    if ent.EntType == "Pod" then
        local rocketLimit = rocketCvar:GetInt()
        if rocketLimit == 0 then return end

        con.totalRockets = con.totalRockets + ent.MagSize
        if con.totalRockets > rocketLimit then
            overLimitEnts[ent] = true
        end
    else
        local missileLimit = missileCvar:GetInt()
        if missileLimit == 0 then return end

        con.totalMissiles = con.totalMissiles + ent.MagSize
        if con.totalMissiles > missileLimit then
            overLimitEnts[ent] = true
        end
    end
end )

hook.Add( "cfw.contraption.entityRemoved", "ACF_Limits_Missiles", function( con, ent )
    if not con or not IsValid( ent ) then return end
    if ent:GetClass() ~= "acf_rack" then return end

    if ent.EntType == "Pod" then
        if rocketCvar:GetInt() == 0 then return end

        con.totalRockets = con.totalRockets - ent.MagSize
    else
        if missileCvar:GetInt() == 0 then return end

        con.totalMissiles = con.totalMissiles - ent.MagSize
    end

    if overLimitEnts[ent] then
        overLimitEnts[ent] = nil
    end
end )

hook.Add( "ACF_IsLegal", "ACF_Limits_Missiles", function( ent )
    if not overLimitEnts[ent] then return end
    if ent:GetClass() ~= "acf_rack" then return end

    local con = ent:GetContraption()
    if not con then return end

    if ent.EntType == "Pod" then
        local rocketLimit = rocketCvar:GetInt()
        if rocketLimit == 0 then return end

        if con.totalRockets > rocketLimit then
            return false, "Rocket Count Limited", "Your weapon would surpass the rocket limit (" .. rocketLimit .. " rockets) and has been disabled."
        else
            overLimitEnts[ent] = nil
        end
    else
        local missileLimit = missileCvar:GetInt()
        if missileLimit == 0 then return end

        if con.totalMissiles > missileLimit then
            return false, "Missile Count Limited", "Your weapon would surpass the missile limit (" .. missileLimit .. " missiles) and has been disabled."
        else
            overLimitEnts[ent] = nil
        end
    end
end )