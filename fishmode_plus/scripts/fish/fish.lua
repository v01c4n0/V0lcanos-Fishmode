

-- create unassemble recipes
unassemble_recipes = {}

ignore_items = {
  -- ["landfill"]=true,
  -- ["used-up-uranium-fuel-cell"]=true,
  ["space-science-pack"]=true
}

ignore_recipe = {
  ["nuclear-fuel-reprocessing"]=true,
  -- ["uranium-processing"]=true,
  ["kovarex-enrichment-process"]=true,
  -- ["uranium-fuel-cell"]=true,
}

require("fish-dissassemble")
require("fish-liquidate")
require("fish-mining")

local golden_fish_icons = {
  {
    icon = "__base__/graphics/icons/fish.png",
    icon_size = 64,
  },
  {
    icon = "__fishmode_plus__/assets/legendary.png",
    scale = 0.4,
    shift = {-4, 4},
  }
}
-- add a golden fish
local golden_fish = {
  type = "item",
  name = "legendary-fish",
  icons = golden_fish_icons,
  icon_size = 64,
  stack_size = 100,
  order = "a-a-a",
  localised_name = {"item-name.legendary-fish"},
}

data:extend({golden_fish, golden_fish_recipe})

--== FISH PROCESSING ==--
local function make_fish_result(item_name, amount)
  return {name=item_name, amount_min=1, amount_max=amount, type="item"}
end

function fish_processing_template(name, icons)
  return {
    enabled = true,
    energy_required = 1,
    type = "recipe",
    -- type = "crafting"
    name = name,
    icons = icons,
    subgroup = "fish-processing",
    localised_name = {"recipe-name."..name},
    allow_as_intermediate = false,
    allow_intermediates = false,
    allow_decomposition = false,
    results = {},
    main_product = "",
    ingredients = {{name="raw-fish", amount=1, type="item"}},
  }
end