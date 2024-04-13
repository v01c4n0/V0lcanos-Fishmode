local table = require("__flib__.table")

local function transferFromFurnacesToAssemblers(furnace_name)
  if data.raw.furnace[furnace_name] then
    local furnace = krastorio_utils.tables.fullCopy(data.raw.furnace[furnace_name])
    furnace.type = "assembling-machine"
    furnace.source_inventory_size = nil
    furnace.energy_usage = "350kW"
    -- Is this redundant?
    data.raw.furnace[furnace_name] = nil
    data:extend({ furnace })
  end
end

-- Automatically convert all furnaces that have the "smelting" category
-- Fill the excludes list with any breakages that are found
local excludes = table.invert({})
for _, furnace in pairs(data.raw["furnace"]) do
  if not excludes[furnace.name] and table.find(furnace.crafting_categories, "smelting") then
    transferFromFurnacesToAssemblers(furnace.name)
  end
end