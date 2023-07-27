local IsValid = IsValid
local timer_Simple = timer.Simple

local cvarFlags = { FCVAR_ARCHIVE, FCVAR_REPLICATED }
local caliberCvar = CreateConVar( "acf_limits_caliber", 500, cvarFlags, "The maximum total ACF caliber of guns that a player can have out at once (in mm). Set to 0 to disable this limit.", 0, 5000 )

local overCaliberEnts = {}
local excludedEnts = {}

local nonLethalAmmo = {
    ["SM"] = true,
    ["FLR"] = true
}

local function totalClamp( total )
    -- This value should never go below 0
    if total and total >= 0 then return end
    total = 0
end

local function clearOnRemove( ent, ply, caliber )
    ent:CallOnRemove( "ACF_Limits_Caliber", function()
        if not IsValid( ent ) or not IsValid( ply ) then return end

        if overCaliberEnts[ent] then
            overCaliberEnts[ent] = nil
        end
        if excludedEnts[ent] then
            excludedEnts[ent] = nil

            return
        end

        if not ply.CaliberTotal then return end
        totalClamp( ply.CaliberTotal )
        ply.CaliberTotal = ply.CaliberTotal - caliber
    end )
end

hook.Add( "OnEntityCreated", "ACF_Limits_Caliber", function( ent )
    timer_Simple( 0, function()
        if not IsValid( ent ) then return end

        local caliberLimit = caliberCvar:GetInt()
        if caliberLimit == 0 then return end
        local entClass = ent:GetClass()
        if entClass ~= "acf_gun" then return end
        if nonLethalAmmo[ent.BulletData.Type] then return end -- TODO: Cvar for excluding nonlethals? Maybe?

        local ply = ent:CPPIGetOwner()
        local entCaliber = ent.Caliber
        if not entCaliber then return end

        totalClamp( ply.CaliberTotal )
        local newTotal = ply.CaliberTotal + entCaliber

        if newTotal > caliberLimit then
            overCaliberEnts[ent] = true
        end

        ply.CaliberTotal = newTotal
        clearOnRemove( ent, ply, entCaliber )
    end )
end )

hook.Add( "PlayerInitialSpawn", "ACF_Limits_Caliber", function( ply )
    ply.CaliberTotal = 0
end )

hook.Add( "ACF_CanCreateEntity", "ACF_Limits_Caliber", function( class, ply, _, _, data )
    local caliberLimit = caliberCvar:GetInt()
    if caliberLimit == 0 then return end
    if class ~= "acf_gun" then return end

    local entCaliber = data.Caliber
    if not entCaliber then return end

    totalClamp( ply.CaliberTotal )
    local newTotal = ply.CaliberTotal + entCaliber

    if newTotal > caliberLimit then return false, "Total caliber limit would be reached! (" .. caliberLimit .. " mm)" end
end )

hook.Add( "ACF_CanUpdateEntity", "ACF_Limits_Caliber", function( ent, data )
    local caliberLimit = caliberCvar:GetInt()
    if caliberLimit == 0 then return end
    local entClass = ent:GetClass()
    if entClass ~= "acf_gun" then return end

    local ply = ent:CPPIGetOwner()
    local caliberOld = ent.Caliber
    local caliberNew = data.Caliber
    if not caliberOld or not caliberNew then return end

    totalClamp( ply.CaliberTotal )
    local newTotal = ply.CaliberTotal + caliberNew - caliberOld

    if newTotal > caliberLimit then return false, "Total caliber limit would be reached! (" .. caliberLimit .. " mm)" end

    ply.CaliberTotal = newTotal
    clearOnRemove( ent, ply, caliberNew )
end )

hook.Add( "ACF_IsLegal", "ACF_Limits_Caliber", function( ent )
    local caliberLimit = caliberCvar:GetInt()

    if caliberLimit == 0 then return end
    local entClass = ent:GetClass()
    if entClass ~= "acf_gun" then return end
    if excludedEnts[ent] then return end

    local ply = ent:CPPIGetOwner()
    if not IsValid( ply ) then return end

    local ammoType = ent.BulletData.Type
    if ammoType == "Empty" then return end
    if nonLethalAmmo[ammoType] then
        local entCaliber = ent.Caliber
        ply.CaliberTotal = ply.CaliberTotal - entCaliber

        excludedEnts[ent] = true
        if overCaliberEnts[ent] then
            overCaliberEnts[ent] = nil
        end

        return
    end

    if not overCaliberEnts[ent] then return end

    if ply.CaliberTotal > caliberLimit then
        return false, "Caliber Limited", "Your weapon would surpass the total caliber limit (" .. caliberLimit .. " mm) and has been disabled."
    else
        overCaliberEnts[ent] = nil
    end
end )