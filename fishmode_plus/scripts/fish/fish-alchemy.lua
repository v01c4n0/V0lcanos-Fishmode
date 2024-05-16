--Define all resources that can be created by fish from scratch
table = require("__flib__/table")
-- Should I add a mod setting for these values or not? I think they're an important part of game balance so I don't think they should be available 
local fishAmount = 2
local rawCraftTime = 6
local craftAmount = 1

local stone = table.deepcopy(data.raw["resource"]["stone"])

local recipe6 = {
	type = "recipe",
    category = "smelting",
    name = "fish-craft-stone",
    enabled = true,
    energy_required = rawCraftTime, 
    ingredients = {{"raw-fish", fishAmount}},
    results =  {
      {type="item", name = "stone", amount = craftAmount}
    }
}

data:extend{stone, recipe6}

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