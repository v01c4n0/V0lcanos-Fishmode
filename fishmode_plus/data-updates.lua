local table = require("__flib__.table")

local function moveFurnaceRecipes(furnace_name)
  if data.raw.furnace[furnace_name] then
    local furnace =  table.deepcopy(data.raw.furnace[furnace_name])
    furnace.type = "assembling-machine"
    furnace.source_inventory_size = nil
    data.raw.furnace[furnace_name] = nil
    data:extend({furnace})
  end
end

for _, furnace in pairs(data.raw["furnace"]) do
  for _, furnace in pairs(data.raw["furnace"]) do
    if table.find(furnace.crafting_categories, "smelting") then
      moveFurnaceRecipes(furnace.name)
    end
  end
end
