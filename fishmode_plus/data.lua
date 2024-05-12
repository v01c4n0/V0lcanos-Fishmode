--Creates all the purely fish-based recipes for raw resources for when they can't be decrafted
--TODO: automate this process in the data-final-fixes file so that all raw resources from any mod can be made this way

inspect = require ("lib/inspect")

--Fish transmutation device prototype
require("prototypes.liquidator")

require("scripts/fish/fish-alchemy.lua")

--Change fish stack size to 200
data.raw["capsule"]["raw-fish"].stack_size = 200

--Increase Assembly Machine pollution by multiplier in settings
log(settings.startup["assembling-machine-pollution-multiplier"].value)
assemblyMachinePollutionMultiplier = (settings.startup["assembling-machine-pollution-multiplier"].value)

data.raw["assembling-machine"]["assembling-machine-1"].energy_source.emissions_per_minute = (4*assemblyMachinePollutionMultiplier)
data.raw["assembling-machine"]["assembling-machine-2"].energy_source.emissions_per_minute = (3*assemblyMachinePollutionMultiplier)
data.raw["assembling-machine"]["assembling-machine-3"].energy_source.emissions_per_minute = (2*assemblyMachinePollutionMultiplier)

--Alter default map generation time evolution factor down to 25 from 40
  data.raw["map-settings"]["map-settings"].enemy_evolution = {
    enabled = true,
    time_factor =       0.0000025,
    destroy_factor =    0.002,
    pollution_factor =  0.0000009
  }