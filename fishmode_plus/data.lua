
krastorio = {}
krastorio.internal_name = "Krastorio2"
krastorio.title_name = "Krastorio 2"
krastorio.version = mods[krastorio.internal_name]
krastorio.stage = "data"

-- -- Global Krastorio 2 Paths
require("__fishmode_custom__/lib/public/data-stages/paths")
require(kr_path .. "lib/private/data-stages/utils/krastorio_utils")


-- Should I add a mod setting for these values or not? I think they're an important part of game balance so I don't think they should be available 
local fishAmount = 2
local rawCraftTime = 3.2
--log(rawCraftTime)

--Creates all the purely fish-based recipes for raw resources for when they can't be decrafted
--TODO: automate this process in the data-final-fixes file so that all raw resources from any mod can be made this way

local ironOre = table.deepcopy(data.raw["resource"]["iron-ore"])

-- create the recipe protocategory from scratch
local recipe5 = {
  category = "smelting",
  type = "recipe",
  name = "fish-craft-iron-ore",
  enabled = true,
  energy_required = rawCraftTime, -- time to craft in seconds (at crafting speed 1)
  ingredients = {{"raw-fish", fishAmount}},
  result = "iron-ore"
}

data:extend{ironOre, recipe5}



local copperOre = table.deepcopy(data.raw["resource"]["copper-ore"]) 

-- create the recipe protocategory from scratch
local recipe4 = {
    type = "recipe",
    category = "smelting",
    name = "fish-craft-copper-ore",
    enabled = true,
    energy_required = rawCraftTime, -- time to craft in seconds (at crafting speed 1)
    ingredients = {{"raw-fish", fishAmount}},
    result = "copper-ore"
}

data:extend{copperOre, recipe4}



local coal = table.deepcopy(data.raw["resource"]["coal"]) 

-- create the recipe protocategory from scratch
local recipe3 = {
	type = "recipe",
    category = "smelting",
    name = "fish-craft-coal",
    enabled = true,
    energy_required = rawCraftTime, -- time to craft in seconds (at crafting speed 1)
    ingredients = {{"raw-fish", fishAmount}},
    result = "coal"
}

data:extend{coal, recipe3}



local oil = table.deepcopy(data.raw["resource"]["crude-oil"]) 

-- create the recipe protocategory from scratch
local recipe2 = {
	type = "recipe",
    category = "oil-processing",
    name = "fish-craft-crude-oil",
    enabled = true,
    energy_required = rawCraftTime, -- time to craft in seconds (at crafting speed 1)
    ingredients = {{"raw-fish", fishAmount}},
    results = {
        {type="fluid", name = "crude-oil", amount = 20}
    }
}

data:extend{oil, recipe2}


 local uraniumOre = table.deepcopy(data.raw["resource"]["uranium-ore"]) 

-- create the recipe protocategory from scratch
local recipe = {
	type = "recipe",
    category = "smelting",
    name = "fish-craft-uranium-ore",
    enabled = true,
    energy_required = rawCraftTime, -- time to craft in seconds (at crafting speed 1)
    ingredients = {{"raw-fish", fishAmount}},
    result = "uranium-ore"
}

data:extend{uraniumOre, recipe}

--log(settings.startup["asssembly-machine-power-consumption"].value)
--[[
assemblyMachinePowerConsumptionMultiplier = ((settings.startup["asssembly-machine-power-consumption"].value)*75)

data.raw["assembling-machine"]["assembling-machine-1"].energy_usage = (1*assemblyMachinePowerConsumptionMultiplier .. "kW")
data.raw["assembling-machine"]["assembling-machine-2"].energy_usage = (2*assemblyMachinePowerConsumptionMultiplier .. "kW")
data.raw["assembling-machine"]["assembling-machine-3"].energy_usage = (5*assemblyMachinePowerConsumptionMultiplier .. "kW")
--]]
local assemblyMachinePollutionMultiplier = ((settings.startup["assembly-machine-pollution-multiplier"].value))


data.raw["assembling-machine"]["assembling-machine-1"].emissions_per_second = (4*assemblyMachinePollutionMultiplier)
data.raw["assembling-machine"]["assembling-machine-2"].emissions_per_second = (3*assemblyMachinePollutionMultiplier)
data.raw["assembling-machine"]["assembling-machine-3"].emissions_per_second = (2*assemblyMachinePollutionMultiplier)


data.raw.capsule["raw-fish"].fuel_category = "fish-fuel"
data.raw.capsule["raw-fish"].fuel_value = "12MJ"

data:extend({
  {
    type = "fuel-category",
    name = "fish-fuel"
  }
  })

  data.raw["map-settings"]["map-settings"].enemy_evolution = {
    enabled = true,
    time_factor =       0.0000025,
    destroy_factor =    0.002,
    pollution_factor =  0.0000009
  }