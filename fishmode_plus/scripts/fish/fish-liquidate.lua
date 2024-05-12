dissassemble = require("fish-dissassemble")

local sortString = ""

local function construct_liquidate_recipe(item_name)
  local icons = util.get_item_icon(item_name)
  
  if icons == false then
    icons = {}
    icons[1] = {icon ="__base__/graphics/icons/signal/signal_X.png", icon_size = 64}
  end

  item_localised_name = {"?",
    {"item-name."..item_name},
    {"entity-name."..item_name},
    {"entity-name."..item_name},
    {"equipment-name."..item_name},
  }

  sortString = "liquidate-" .. item_name
  local new_recipe = {
    category = "fishy-liquidate",
    name = "liquidate-"..item_name,
    localised_name = {"Liquidate ", item_localised_name},
    order = sortString,



    ingredients = {
      {
        item_name,
        1
      }
    },
    results = {},
    -- main_product = "",
    icons = icons,
    allow_decomposition = false,
    subgroup = "fishy-liquidate",
    type = "recipe",
    energy_required = 500,
    allow_as_intermediate = false,
    allow_intermediates = false,
    enabled = true,
    hide_from_player_crafting = true,
  }
  return new_recipe
end

--Creates liquidate recipes
for item_name, item_data in pairs(item_ranking.item_data) do
  if item_data.is_fluid or item_data.is_science or ignore_items[item_name] then
    goto continue
  end

  local item_recipe = item_data.canonical_recipe
  -- log("canon RECIPE FOR "..item_name..": "..item_recipe)
  if item_recipe ~= "" then
    local removed_ingredients = removed_ingredients_by_recipe[item_recipe]
    if not removed_ingredients or #removed_ingredients == 0 then
      goto continue
    end

    assert(#removed_ingredients == 1, "more than one removed ingredient")


    local ingr = removed_ingredients[1]

    local result_chance = 1.0
    local result_amount = ingr.amount/item_data.made_in_batch_of_size

    local new_recipe = construct_unassemble_recipe(item_name, ingr.name)
    local result_is_fluid = item_ranking.item_data[ingr.name].is_fluid
    if result_is_fluid then
      new_recipe.category = "crafting-with-fluid"
    end

    -- result_amount = result_amount * #util.get_normalized_recipe_ingredients(item_recipe)
    
    if result_amount < 1 then
      if result_amount > 0.1 then
        result_chance = math.floor(result_amount * 10) / 10
      else
        result_chance = math.floor(result_amount * 100) / 100
      end
      result_amount = 1
    end
    if result_chance <= 0 then
      result_chance = 0.01
    end
    
    local base_probability = result_chance

    local new_result = util.make_unassemble_result(ingr.name, result_amount, result_chance)



    -- new_result.probability = base_probability
    table.insert(new_recipe.results, new_result)
    -- assert(new_result.type ~= "fluid" or new_recipe.category == "chemistry", "fluid detected in unassemble recipe! " .. item_name)

    if result_is_fluid then
      local result = new_recipe.results[1]
      -- result_amount = result_amount * #util.get_normalized_recipe_ingredients(item_recipe)
      result.amount_min = 0
      result.amount_max = result.amount * 10
      result.amount = nil
      new_recipe.probability = nil
    else
      for i=#util.get_normalized_recipe_ingredients(item_recipe),1 , -1 do
        additional_result = table.deepcopy(new_result)
        new_result.probability = base_probability
        table.insert(new_recipe.results, new_result)
      end
    end

    new_recipe.main_product = "" -- fixes a tooltip issue
    table.insert(unassemble_recipes, new_recipe)
  end
  ::continue::
end

-- create liquidate recipes
for item_name, item_data in pairs(item_ranking.item_data) do
  -- local canonical_recipe = item_data.canonical_recipe

  
  --(0.5 * item_data.value)
log("Item name is" .. inspect(item_name) .. "\nItem value is:" .. inspect(item_data.value))

local item_value = item_data.value

if item_name == "space-science-pack" then
  item_value= 0 
end

local value_mult = 1
if item_data.complexity ~= nil then
  value_mult = math.max(1, math.pow(item_data.complexity, 1/3))
end
item_ranking.item_data[item_name].value_mult = value_mult

local num_fish = (item_value) * value_mult
  num_fish = math.min(65535, num_fish)

  local fish_chance = 1.0

  if item_data.is_fluid or ignore_items[item_name] then
    goto continue
  end
  if item_value == 0 or item_value == nil or item_name == "raw-fish" or item_data.is_base_item then
    goto continue
  end


  num_fish = math.floor(num_fish)
  if num_fish < 1 then
    num_fish = 1
  end

  -- add the fish to the recipe results
  local new_recipe = construct_liquidate_recipe(item_name)
  -- whitelist for productivity modules
  for _, module in pairs(data.raw.module) do
    if module.category == "productivity" and module.limitation then
      table.insert(module.limitation, new_recipe.name)
      log("added "..new_recipe.name.." to "..module.name)
    end
  end

  table.insert(new_recipe.results, util.make_unassemble_result("raw-fish", num_fish, 1))
  new_recipe.energy_required = (0.1 * item_value)
  table.insert(unassemble_recipes, new_recipe)
  log("Liquidate Recipe data for " .. new_recipe.name .. " is: " .. inspect(new_recipe))
  ::continue::
end