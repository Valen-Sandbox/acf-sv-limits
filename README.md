# acf-sv-limits
A set of easily configurable tools that server owners can use to place limits on commonly abused aspects of ACF-3 and fine-tune their server experiences.

Please be aware that this addon is still somewhat WIP and potentially subject to change in behavior if you're using this.

## ConVars
- **acf_limits_ammobomb**: Prevents ammo/fuel boxes from detonating when not connected to any components if enabled.
- **acf_limits_caliber**: The maximum total ACF caliber of guns that a player can have out at once (in mm). Set to 0 to disable limitations.
- **acf_limits_caliber_nonlethals**: Determines whether non-lethal entities (loaded with smoke/flares) should count towards the caliber limit.
- **acf_limits_mass**: The maximum mass that a contraption may have before its weapons/engines are disabled (in whole kg). Set to 0 to disable limitations.
- **acf_limits_missiles**: The maximum number of missiles that a contraption may hold before further racks are disabled. Set to 0 to disable limitations.
- **acf_limits_parentdist**: The maximum distance that parented weapons/engines/ammo boxes can be from their root parent (in Source units). Set to 0 to disable limits.
- **acf_limits_rockets**: The maximum number of rockets that a contraption may hold before further racks are disabled. Set to 0 to disable limitations.
- **acf_limits_setnotsolid**: Removes the ability to make vehicle entities not solid if enabled.
- **acf_limits_worldweld**: Removes the ability to weld contraptions to the world if enabled. This is intended to prevent certain exploits that use this method.

Additionally, because this addon uses the same loader module as ACF, the following is also available:
- The hook **ACF_Limits_OnLoadAddon** (runs after the addon is fully loaded)
- The concommand **acf_limits_reload** (reloads the addon)

## Requirements
- [ACF-3](https://github.com/Stooberton/ACF-3)
- [CFW](https://github.com/Stooberton/CFW)
- Any CPPI-based prop protection addon
