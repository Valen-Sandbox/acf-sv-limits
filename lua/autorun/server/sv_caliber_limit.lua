local IsValid = IsValid
local timer_Simple = timer.Simple

local cvarFlags = { FCVAR_ARCHIVE, FCVAR_REPLICATED }
local caliberCvar = CreateConVar( "acf_limits_caliber", 5000, cvarFlags, "The maximum total ACF caliber that a player can have out at once (in mm).", 0, 5000 )

local overCaliberEnts = {}

local function totalClamp( total )
    -- This value should never go below 0
    if total >= 0 then return end
    total = 0
end

local function clearOnRemove( ent, ply, caliber )
    ent:CallOnRemove( "ACF_Limits_Caliber", function()
        if not IsValid( ent ) then return end

        if overCaliberEnts[ent] then
            overCaliberEnts[ent] = nil
        end

        totalClamp( ply.CaliberTotal )
        ply.CaliberTotal = ply.CaliberTotal - caliber
    end )
end

hook.Add( "PlayerInitialSpawn", "ACF_Limits_Caliber", function( ply )
    ply.CaliberTotal = 0
end )

hook.Add( "ACF_CanCreateEntity", "ACF_Limits_Caliber", function( class, ply, _, _, data )
    if class ~= ( "acf_gun" or "acf_rack" ) then return end

    local caliberLimit = caliberCvar:GetInt()
    local entCaliber = data.Caliber

    totalClamp( ply.CaliberTotal )
    local newTotal = ply.CaliberTotal + entCaliber

    if newTotal > caliberLimit then return false, "Total caliber limit would be reached! (" .. caliberLimit .. " mm)" end
end )

hook.Add( "ACF_CanUpdateEntity", "ACF_Limits_Caliber", function( ent, data )
    if ent:GetClass() ~= ( "acf_gun" or "acf_rack" ) then return end

    local ply = ent:CPPIGetOwner()
    local caliberLimit = caliberCvar:GetInt()
    local caliberOld = ent.Caliber
    local caliberNew = data.Caliber

    totalClamp( ply.CaliberTotal )
    local newTotal = ply.CaliberTotal + caliberNew - caliberOld

    if newTotal > caliberLimit then return false, "Total caliber limit would be reached! (" .. caliberLimit .. " mm)" end

    ply.CaliberTotal = newTotal
    clearOnRemove( ent, ply, caliberNew )
end )

hook.Add( "OnEntityCreated", "ACF_Limits_Caliber", function( ent )
    timer_Simple( 0, function()
        if not IsValid( ent ) then return end
        if ent:GetClass() ~= ( "acf_gun" or "acf_rack" ) then return end
        if ent.BulletData.Type == "SM" then return end -- TODO: Cvar for excluding smokes? Maybe?

        local ply = ent:CPPIGetOwner()
        local caliberLimit = caliberCvar:GetInt()
        local entCaliber = ent.Caliber

        totalClamp( ply.CaliberTotal )
        local newTotal = ply.CaliberTotal + entCaliber

        if newTotal > caliberLimit then
            overCaliberEnts[ent] = true
        end

        ply.CaliberTotal = ply.CaliberTotal + entCaliber
        clearOnRemove( ent, ply, ent.Caliber )
    end )
end )

hook.Add( "ACF_IsLegal", "ACF_Limits_Caliber", function( ent )
    if not overCaliberEnts[ent] then return end
    if ent:GetClass() ~= ( "acf_gun" or "acf_rack" ) then return end
    if ent.BulletData.Type == "SM" then return end

    local ply = ent:CPPIGetOwner()
    local caliberLimit = caliberCvar:GetInt()

    if ply.CaliberTotal > caliberLimit then
        return false, "Caliber Limited", "Your weapon would surpass the total caliber limit (" .. caliberLimit .. " mm) and has been disabled."
    else
        overCaliberEnts[ent] = nil
    end
end )