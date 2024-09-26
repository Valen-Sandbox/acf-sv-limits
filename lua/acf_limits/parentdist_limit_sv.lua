local cvarFlags = { FCVAR_ARCHIVE, FCVAR_REPLICATED }
local distCvar = CreateConVar( "acf_limits_parentdist", 512, cvarFlags, "The maximum distance that parented weapons/engines/ammo boxes can be from their root parent (in Source units). Set to 0 to disable limits.", 0 )

local disabledEnts = {
    ["acf_gun"] = true,
    ["acf_rack"] = true,
    ["acf_engine"] = true,
    ["acf_radar"] = true,
    ["acf_ammo"] = true
}

hook.Add( "ACF_OnCheckLegal", "ACF_Limits_ParentDist", function( ent )
    local distLimit = distCvar:GetInt()
    if distLimit == 0 then return end
    if not disabledEnts[ent:GetClass()] then return end

    local fam = ent:GetFamily()
    if not fam then return end

    local root = fam:GetRoot()
    if not root then return end

    local entPos = ent:GetPos()
    local rootPos = root:GetPos()

    if entPos:DistToSqr( rootPos ) > distLimit * distLimit then
        return false, "Parent Distance Limited", "Your component would surpass the root parent distance limit (" .. distLimit .. " units) and has been disabled."
    end
end )