# acf-sv-limits
A set of tools that server owners can use to place limits on commonly abused aspects of ACF-3. There's currently not much in here, but more is planned to come (hopefully).

Please be aware that this addon is still fairly WIP and subject to change in behavior if you're using this.

## ConVars
- **acf_limits_caliber**: The maximum total ACF caliber that a player can have out at once (in mm). Set to 0 to disable limitations.
- **acf_limits_mass**: The maximum mass that a contraption may have before its weapons/engines are disabled (in whole kg). Set to 0 to disable limitations.
- **acf_limits_missiles**: The maximum number of missiles that a contraption may hold before further racks are disabled. Set to 0 to disable limitations.
- **acf_limits_rockets**: The maximum number of rockets that a contraption may hold before further racks are disabled. Set to 0 to disable limitations.
- **acf_limits_worldweld**: Removes the ability to weld contraptions to the world if enabled. This is intended to prevent instantly stopping brakes that use this method.

## Requirements
- [ACF-3](https://github.com/Stooberton/ACF-3)
- [CFW](https://github.com/Stooberton/CFW)
- Any CPPI-based prop protection addon