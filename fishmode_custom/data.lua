
krastorio = {}
krastorio.internal_name = "Krastorio2"
krastorio.title_name = "Krastorio 2"
krastorio.version = mods[krastorio.internal_name]
krastorio.stage = "data"

-- -- Global Krastorio 2 Paths
require("__fishmode_custom__/lib/public/data-stages/paths")
require(kr_path .. "lib/private/data-stages/utils/krastorio_utils")


-- Should I add a mod setting for these values or not? I think they're an important part of game balance so I don't think they should be available 
local fishAmount = 5
local rawCraftTime = 6.4
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

--log(settings.startup["Asssembly-Machine-Power-Consumption"].value)
assemblyMachinePowerConsumptionMultiplier = ((settings.startup["Asssembly-Machine-Power-Consumption"].value)*75)

data.raw["assembling-machine"]["assembling-machine-1"].energy_usage = (1*assemblyMachinePowerConsumptionMultiplier .. "kW")
data.raw["assembling-machine"]["assembling-machine-2"].energy_usage = (2*assemblyMachinePowerConsumptionMultiplier .. "kW")
data.raw["assembling-machine"]["assembling-machine-3"].energy_usage = (5*assemblyMachinePowerConsumptionMultiplier .. "kW")


data.raw.capsule["raw-fish"].fuel_category = "fish-fuel"
data.raw.capsule["raw-fish"].fuel_value = "12MJ"

data:extend({
  {
    type = "fuel-category",
    name = "fish-fuel"
  }
  })

data.raw["map-gen-presets"].default["default"] = {
    order = "a",
    advanced_settings = {
        enemy_evolution = {
            time_factor = 0.0000025,
        },
    }
}

--[=[
    ["rich-resources"] =
    {
      order = "b",
      basic_settings =
      {
        autoplace_controls =
        {
          ["iron-ore"] = { richness = "very-good"},
          ["copper-ore"] = { richness = "very-good"},
          ["stone"] = { richness = "very-good"},
          ["coal"] = { richness = "very-good"},
          ["uranium-ore"] = { richness = "very-good"},
          ["crude-oil"] = { richness = "very-good"}
        }
      }
    },
    ["marathon"] =
    {
      order = "c",
      advanced_settings =
      {
        difficulty_settings =
        {
          recipe_difficulty = defines.difficulty_settings.recipe_difficulty.expensive,
          technology_difficulty = defines.difficulty_settings.technology_difficulty.expensive,
          technology_price_multiplier = 4
        }
      }
    },
    ["dangerous"] =
    {
      order = "d",
      basic_settings =
      {
        autoplace_controls =
        {
          ["enemy-base"] = { frequency = "very-high"}
        }
      },
      advanced_settings =
      {
        enemy_evolution =
        {
          time_factor = 0.00002,
          pollution_factor = 0.00002
        }
      }
    },
    ["death-world"] =
    {
      order = "d",
      basic_settings =
      {
        autoplace_controls =
        {
          ["enemy-base"] = { frequency = "very-high"}
        }
      },
      advanced_settings =
      {
        enemy_evolution =
        {
          time_factor = 0.00002,
          pollution_factor = 0.00002
        },
        difficulty_settings =
        {
          recipe_difficulty = defines.difficulty_settings.recipe_difficulty.expensive,
          technology_difficulty = defines.difficulty_settings.technology_difficulty.expensive,
          technology_price_multiplier = 4
        }
      }
    },
    ["rail-world"] =
    {
      order = "e",
      basic_settings =
      {
        autoplace_controls = {
          coal = {
            frequency = "very-low",
            size = "high"
          },
          ["copper-ore"] = {
            frequency = "very-low",
            size = "high"
          },
          ["crude-oil"] = {
            frequency = "low",
            size = "high"
          },
          ["uranium-ore"] = {
            frequency = "low",
            size = "high"
          },
          ["enemy-base"] = {
            frequency = "low",
          },
          ["iron-ore"] = {
            frequency = "very-low",
            size = "high"
          },
          stone = {
            frequency = "very-low",
            size = "high"
          }
        },
        terrain_segmentation = "very-low",
        water = "high",
      },
      advanced_settings =
      {
        enemy_evolution =
        {
          time_factor = 0.000002
        },
        enemy_expansion =
        {
         enabled = false
        }
      }
    },
     ["wear-tear"] =
    {
      order = "f",
      basic_settings =
      {
        autoplace_controls =
        {
          ["angels-ore1"] = { frequency = "low", size = "high", richness = "good"},
          ["angels-ore2"] = { frequency = "low", size = "high", richness = "good"},
          ["angels-ore3"] = { frequency = "low", size = "high", richness = "good"},
          ["angels-ore4"] = { frequency = "low", size = "high", richness = "good"},
          ["angels-ore5"] = { frequency = "low", size = "high", richness = "good"},
          ["angels-ore6"] = { frequency = "low", size = "high", richness = "good"},
          ["angels-fissure"] = { frequency = "low", size = "high", richness = "very-good"},
          ["angels-natural-gas"] = { frequency = "low", size = "high", richness = "very-good"},
          ["coal"] = { frequency = "low", size = "high", richness = "very-good"},
          ["crude-oil"] = { frequency = "low", size = "high", richness = "very-good"}
         }, terrain_segmentation = "low", water = "very-high",
      },
     advanced_settings = {enemy_evolution = {time_factor = 0, pollution_factor = 0.000008}}
    }
  }
})
--]=]