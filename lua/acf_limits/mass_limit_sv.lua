local cvarFlags = { FCVAR_ARCHIVE, FCVAR_REPLICATED }
local massCvar = CreateConVar( "acf_limits_mass", 61000, cvarFlags, "The maximum mass that a contraption may have before its weapons are disabled (in whole kg). Set to 0 to disable this limit.", 0 )

local disabledEnts = {
    ["acf_gun"] = true,
    ["acf_rack"] = true,
    ["acf_engine"] = true
}

hook.Add( "ACF_OnCheckLegal", "ACF_Limits_Mass", function( ent )
    local massLimit = massCvar:GetInt()
    if massLimit == 0 then return end
    if not disabledEnts[ent:GetClass()] then return end

    local con = ent:GetContraption()
    if not con then return end

    if con.totalMass >= massLimit then return false, "Mass Limited", "Your contraption would surpass the mass limit (" .. massLimit .. " kg) and has been disabled." end
end )