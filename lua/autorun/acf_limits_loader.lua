-- gLoader isn't actually shipped in this addon because it's already used by ACF-3
hook.Add( "ACF_OnLoadAddon", "ACF_Limits_Loader", function()
    gloader.Load( "ACF_Limits", "acf_limits" )
    hook.Remove( "ACF_OnLoadAddon", "ACF_Limits_Loader" )
end )