local IsValid = IsValid
local timer_Simple = timer.Simple
local CreateConVar = CreateConVar
local hook_Add = hook.Add

local cvarFlags = { FCVAR_ARCHIVE, FCVAR_REPLICATED }

local caliberCvar = CreateConVar( "acf_limits_caliber", 5000, cvarFlags, "The maximum total ACF caliber that a player can have out at once (in mm).", 0, 5000 )
local overCaliberEnts = {}

hook_Add( "PlayerInitialSpawn", "ACF_Limits_Caliber", function( ply )
    ply.CaliberTotal = 0
end )

hook_Add( "ACF_CanCreateEntity", "ACF_Limits_Caliber", function( _, ply, _, _, data )
    local caliberLimit = caliberCvar:GetInt()
    local entCaliber = data.Caliber

    -- This value should never go below 0
    if ply.CaliberTotal < 0 then
        ply.CaliberTotal = 0
    end

    local newTotal = ply.CaliberTotal + entCaliber
    if newTotal > caliberLimit then return false, "ACF total caliber limit would be reached! (" .. caliberLimit .. " mm)" end
end )

hook_Add( "ACF_CanUpdateEntity", "ACF_Limits_Caliber", function( ent, data )
    if ent:GetClass() ~= ( "acf_gun" or "acf_rack" ) then return end
    local ply = ent:CPPIGetOwner()
    local caliberLimit = caliberCvar:GetInt()
    local caliberOld = ent.Caliber
    local caliberNew = data.Caliber

    -- This value should never go below 0
    if ply.CaliberTotal < 0 then
        ply.CaliberTotal = 0
    end

    local newTotal = ply.CaliberTotal + caliberNew - caliberOld
    if newTotal > caliberLimit then return false, "ACF total caliber limit would be reached! (" .. caliberLimit .. " mm)" end
    ply.CaliberTotal = ply.CaliberTotal + caliberNew - caliberOld

    ent:CallOnRemove( "ACF_Limits_Caliber", function()
        if overCaliberEnts[ent] then
            overCaliberEnts[ent] = nil
        end

        if ply.CaliberTotal < 0 then
            ply.CaliberTotal = 0
        end

        ply.CaliberTotal = ply.CaliberTotal - caliberNew
    end )
end )

hook_Add( "OnEntityCreated", "ACF_Limits_Caliber", function( ent )
    timer_Simple( 0, function()
        if not IsValid( ent ) or ent:GetClass() ~= ( "acf_gun" or "acf_rack" ) then return end
        local ply = ent:CPPIGetOwner()
        local caliberLimit = caliberCvar:GetInt()
        local entCaliber = ent.Caliber

        -- This value should never go below 0
        if ply.CaliberTotal < 0 then
            ply.CaliberTotal = 0
        end

        local newTotal = ply.CaliberTotal + entCaliber

        if newTotal > caliberLimit then
            overCaliberEnts[ent] = true
        end

        ply.CaliberTotal = ply.CaliberTotal + entCaliber

        ent:CallOnRemove( "ACF_Limits_Caliber", function()
            if overCaliberEnts[ent] then
                overCaliberEnts[ent] = nil
            end

            if ply.CaliberTotal < 0 then
                ply.CaliberTotal = 0
            end

            ply.CaliberTotal = ply.CaliberTotal - ent.Caliber
        end )
    end )
end )

hook_Add( "ACF_IsLegal", "ACF_Limits_Caliber", function( ent )
    if not overCaliberEnts[ent] then return end
    if ent:GetClass() ~= ( "acf_gun" or "acf_rack" ) then return end

    local ply = ent:CPPIGetOwner()
    local caliberLimit = caliberCvar:GetInt()

    if ply.CaliberTotal > caliberLimit then
        return false, "Caliber Limited", "Your weapon would surpass the total caliber limit (" .. caliberLimit .. " mm) and has been disabled."
    else
        overCaliberEnts[ent] = nil
    end
end )