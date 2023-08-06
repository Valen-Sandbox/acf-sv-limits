local entMeta = FindMetaTable( "Entity" )

local cvarFlags = { FCVAR_ARCHIVE, FCVAR_REPLICATED }
local snsCvar = CreateConVar( "acf_limits_setnotsolid", 1, cvarFlags, "Removes the ability to use SetNotSolid on vehicle entities if enabled.", 0, 1 )

hook.Add( "Initialize", "ACF_Limits_SetNotSolid", function()
    timer.Simple( 0, function()
        local setNotSolid = entMeta.SetNotSolid
        local setSolid = entMeta.SetSolid

        function entMeta:SetNotSolid( solid )
            if solid and snsCvar:GetBool() and self:IsVehicle() then return end

            return setNotSolid( self, solid )
        end

        function entMeta:SetSolid( solid_type )
            if solid_type == 0 and snsCvar:GetBool() and self:IsVehicle() then return end

            return setSolid( self, solid_type )
        end
    end )

    hook.Remove( "Initialize", "ACF_Limits_SetNotSolid" )
end )