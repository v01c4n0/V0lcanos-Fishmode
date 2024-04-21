-- Should I add a mod setting for these values or not? I think they're an important part of game balance so I don't think they should be available 
local fishAmount = 2
local rawCraftTime = 8
local craftAmount = 1
--log(rawCraftTime)

--Creates all the purely fish-based recipes for raw resources for when they can't be decrafted
--TODO: automate this process in the data-final-fixes file so that all raw resources from any mod can be made this way

local ironOre = table.deepcopy(data.raw["resource"]["iron-ore"])

local recipe5 = {
  category = "smelting",
  type = "recipe",
  name = "fish-craft-iron-ore",
  enabled = true,
  energy_required = rawCraftTime, 
  ingredients = {{"raw-fish", fishAmount}},
  results =  {
    {type="item", name = "iron-ore", amount = craftAmount}
  }
}

data:extend{ironOre, recipe5}



local copperOre = table.deepcopy(data.raw["resource"]["copper-ore"]) 


local recipe4 = {
    type = "recipe",
    category = "smelting",
    name = "fish-craft-copper-ore",
    enabled = true,
    energy_required = rawCraftTime, 
    ingredients = {{"raw-fish", fishAmount}},
    results =  {
      {type="item", name = "copper-ore", amount = craftAmount}
    }
}

data:extend{copperOre, recipe4}



local coal = table.deepcopy(data.raw["resource"]["coal"]) 


local recipe3 = {
	type = "recipe",
    category = "smelting",
    name = "fish-craft-coal",
    enabled = true,
    energy_required = rawCraftTime, 
    ingredients = {{"raw-fish", fishAmount}},
    results =  {
      {type="item", name = "coal", amount = craftAmount}
    }
}

data:extend{coal, recipe3}



local oil = table.deepcopy(data.raw["resource"]["crude-oil"]) 


local recipe2 = {
	type = "recipe",
    category = "oil-processing",
    name = "fish-craft-crude-oil",
    enabled = true,
    energy_required = rawCraftTime, 
    ingredients = {{"raw-fish", fishAmount}},
    results = {
        {type="fluid", name = "crude-oil", amount = 20 * craftAmount}
    }
}

data:extend{oil, recipe2}


local uraniumOre = table.deepcopy(data.raw["resource"]["uranium-ore"]) 


local recipe = {
	type = "recipe",
    category = "smelting",
    name = "fish-craft-uranium-ore",
    enabled = true,
    energy_required = rawCraftTime, 
    ingredients = {{"raw-fish", fishAmount}},
    results =  {
      {type="item", name = "uranium-ore", amount = craftAmount}
    }
}

data:extend{uraniumOre, recipe}

--log(settings.startup["asssembly-machine-power-consumption"].value)
--[[
assemblyMachinePowerConsumptionMultiplier = ((settings.startup["asssembly-machine-power-consumption"].value)*75)

data.raw["assembling-machine"]["assembling-machine-1"].energy_usage = (1*assemblyMachinePowerConsumptionMultiplier .. "kW")
data.raw["assembling-machine"]["assembling-machine-2"].energy_usage = (2*assemblyMachinePowerConsumptionMultiplier .. "kW")
data.raw["assembling-machine"]["assembling-machine-3"].energy_usage = (5*assemblyMachinePowerConsumptionMultiplier .. "kW")
--]]

log(settings.startup["assembling-machine-pollution-multiplier"].value)
assemblyMachinePollutionMultiplier = (settings.startup["assembling-machine-pollution-multiplier"].value)

data.raw["assembling-machine"]["assembling-machine-1"].energy_source.emissions_per_minute = (4*assemblyMachinePollutionMultiplier)
data.raw["assembling-machine"]["assembling-machine-2"].energy_source.emissions_per_minute = (3*assemblyMachinePollutionMultiplier)
data.raw["assembling-machine"]["assembling-machine-3"].energy_source.emissions_per_minute = (2*assemblyMachinePollutionMultiplier)


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