-- add a small chance to fish up random items
fishable_items = {}

if not settings.startup["use-normal-mapgen"].value then
    mapgen.modify_mapgen()
end

local function make_unassemble_result(item_name, amount, probability)
    local result_type = "item"
    if item_ranking.item_data[item_name].is_fluid then
      result_type = "fluid"
    end
    local result = {
      name = item_name,
      amount = amount,
      probability = probability,
      type = result_type,
    }
    return result
  end


function add_fish_minable_result(item_name, amount, probability)
    table.insert(data.raw["fish"]["fish"].minable.results, make_unassemble_result(item_name, amount, probability))
  end
  
  add_fish_minable_result("automation-science-pack", 1, 1)
  add_fish_minable_result("logistic-science-pack", 1, 0.25)
  add_fish_minable_result("military-science-pack", 1, 0.05)
  add_fish_minable_result("chemical-science-pack", 1, 0.05)
  add_fish_minable_result("production-science-pack", 1, 0.01)
  add_fish_minable_result("utility-science-pack", 1, 0.01)



  --pretty sure this function's purpose was to create the condensed fish recipes (which are not in use currently)
--[[
  local fish_conversion_recipes = {}
  function condense_fish_template(name)
    return {
      name = name,
      enabled = true,
      energy_required = 0.5,
      type = "recipe",
      -- type = "crafting"
      -- icons = icons,
      subgroup = "fish-processing",
      -- allow_as_intermediate = false,
      -- allow_intermediates = false,
      -- allow_decomposition = false,
      -- results = {},
      hide_from_stats = true,
      ingredients = {},
    }
  end
--]]