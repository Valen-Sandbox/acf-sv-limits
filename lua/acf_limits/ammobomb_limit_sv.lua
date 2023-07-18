local next = next

local cvarFlags = { FCVAR_ARCHIVE, FCVAR_REPLICATED }
local bombCvar = CreateConVar( "acf_limits_ammobomb", 1, cvarFlags, "Prevents ammo/fuel boxes from detonating when not connected to any components if enabled.", 0, 1 )

hook.Add( "ACF_AmmoExplode", "ACF_Limits_AmmoBomb", function( ent )
    if not bombCvar:GetBool() then return end
    local entWeps = ent.Weapons
    if not ( entWeps and next( entWeps ) ) then return false end
end )

hook.Add( "ACF_FuelExplode", "ACF_Limits_FuelBomb", function( ent )
    if not bombCvar:GetBool() then return end
    local entEngines = ent.Engines
    if not ( entEngines and next( entEngines ) ) then return false end
end )