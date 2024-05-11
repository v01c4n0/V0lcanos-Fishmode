--library for creating human readable outputs from any value, including nested tables
--if you want to view what the fuck is going wrong with a value write log(inspect(value))
inspect = require ("inspect")


util = require("util")


mapgen = require("mapgen")

item_ranking = require("item-ranking")

--Adds description line for complexity


--Fish transmutation device prototype. 
require("prototypes.liquidator")

--TODO: clean up this garbage mess

local energy_required_for_unassemble_recipes = 3

local i = 0

-- seed rng
-- util.seed_rng(settings.startup["fishblock-seed"].value)




function denominate_fish(number)
  -- Calculate the number of k^2 factors
  assert(number < 65536, "number of fish is too large")
  return {
    {name="raw-fish", amount=number, type="item"}
  }
  -- local k = 64
  -- number = math.floor(number)

  -- local squared_factors = math.floor(number / (k * k))
  -- number = number % (k * k)

  -- -- Calculate the number of k factors
  -- local factors = math.floor(number / k)
  -- number = number % k

  -- local function fish_result(name, amount)
  --   return {name=name, amount=amount, probability=1.0, type="item"}
  -- end

  -- results = {}
  -- if number > 0 then
  --   table.insert(results, fish_result("raw-fish", number))
  -- end
  -- if factors > 0 then
  --   table.insert(results, fish_result("many-fish", factors))
  -- end
  -- if squared_factors > 0 then
  --   table.insert(results, fish_result("very-many-fish", squared_factors))
  -- end

  -- return results
end


-- stacked fish prototypes
-- data:extend(require("prototypes.manyfish"))


local unrecipes = {}

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

local function construct_unassemble_recipe(item_name, produced_item_name)
  -- local item_data = item_ranking.item_data[item_name]
  -- icon for our new recipe
  local icons = util.get_item_icon(item_name)
  if not icons then
    icons = {{icon ="__base__/graphics/icons/signal/signal_X.png", icon_size = 64}}
  end
  --changes scale to 0.8 the original
  if icons[1].scale then icons[1].scale =  icons[1].scale * 0.8 else icons[1].scale = 0.35 end
  icons[3] = icons[1]
  -- local canonical_recipe = item_ranking.item_data[item_name].canonical_recipe


  -- icons[1].scale = {-0.5, 0.5}
  -- icons[1].shift = {2, 2}
  -- icons[1].tint = {r = 1.0, g = 0.8, b = 0.8, a = 1}
  --icons[1].scale = 0.

  table.insert(icons, 1, {
    icon = "__base__/graphics/icons/deconstruction-planner.png",
    icon_size = 64,
    scale = 0.42,
    -- shift = {-10, -10},
    tint = {r=0.45, g=0.45, b=0.45, a=1}
  })
  
  local extra_icon = util.get_item_icon(produced_item_name)
  if extra_icon then
    -- extra_icon.icon_size = 64
    extra_icon[1].scale = 0.30
    extra_icon[1].shift = {10, -10}
    if extra_icon[1].tint then extra_icon[1].tint.alpha = 0.5 else extra_icon[1].tint = {r=1, g=1, b=1, a=0.5} end
    table.insert(icons, 2 , extra_icon[1])
  end

  log("Recipe name: ".. item_name .. "\nicons: " .. inspect(icons))

  item_localised_name = {"?",
    {"item-name."..item_name},
    {"entity-name."..item_name},
    {"entity-name."..item_name},
    {"equipment-name."..item_name},
  }

  local sortString = ""
  local sortValueProducedItemCost = 0
  local sortValueItemCost = 0

  if item_ranking.item_data[produced_item_name].value then sortValueProducedItemCost = math.floor(item_ranking.item_data[produced_item_name].value*100) end
  for p = 5, 0, -1 do
    sortString = sortString .. string.char(97+math.fmod(math.floor(sortValueProducedItemCost/26^p), 26))
  end
  sortString = sortString .. produced_item_name
  log("Produced Item Value is: " .. sortValueProducedItemCost)
  if item_ranking.item_data[item_name].value then sortValueItemCost = math.floor(item_ranking.item_data[item_name].value*100) end
  log("Deconstructed Item Value is: " .. sortValueItemCost)
  for p = 5, 0, -1 do
    sortString = sortString .. string.char(97+math.fmod(math.floor((sortValueItemCost/26^p)), 26))
  end
  log("Order field is: " .. sortString)
  log("Produced Item name is: ".. produced_item_name .. "\nDeconstructed item name is: ".. item_name)



  local new_recipe = {
    category = "crafting",
    name = "unassemble-"..item_name,
    localised_name = {"fishy-unassemble", item_localised_name},
    order = sortString,
    ingredients = {
      {
        item_name,
        1
      }
    },
    results = {},
    icons = icons,
    allow_decomposition = false,
    subgroup = "fishy-unassemble",
    type = "recipe",
    main_product = produced_item_name,
    energy_required = energy_required_for_unassemble_recipes,
    allow_as_intermediate = false,
    allow_intermediates = false,
    enabled = false,
  }
  return new_recipe
end

local function construct_liquidate_recipe(item_name, i)
  local icons = util.get_item_icon(item_name)
  if not icons then
    icons[1] = {icon ="__base__/graphics/icons/signal/signal_X.png", icon_size = 64}
  end

  item_localised_name = {"?",
    {"item-name."..item_name},
    {"entity-name."..item_name},
    {"entity-name."..item_name},
    {"equipment-name."..item_name},
  }



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


local value_of_fish = 1
local function get_ingredients_total_value(ingredients, recipe_name)
  local total = 0

  local ingredient_name = ingredients[1].name
  local ingredient_amount = ingredients[1].amount
  log(inspect(ingredients))
  log(ingredient_name)
  log(recipe_name)
  --log(inspect(item_ranking.recipe_data[recipe_name]))
  total = item_ranking.item_data[ingredient_name].value * item_ranking.item_data[ingredient_name].made_in_batch_of_size
  return total / value_of_fish
end


local ignore_recipe = {
  ["nuclear-fuel-reprocessing"]=true,
  -- ["uranium-processing"]=true,
  ["kovarex-enrichment-process"]=true,
  -- ["uranium-fuel-cell"]=true,
}

local function fishify_recipe(recipe_name, for_expensive_mode, iterator)
  local ingredients = util.get_normalized_recipe_ingredients(recipe_name, for_expensive_mode)
  local recipe = data.raw.recipe[recipe_name]

  local new_ingredients = table.deepcopy(ingredients)
  local removed_ingredients = {}
  local returnthis = nil
  local total_fish = 0
  local flippable_indexes = {}

  -- ignore smelting recipes and blacklistes recipes
  if recipe.category == "smelting" or ignore_recipe[recipe_name] then
    -- log("SKIPPING RECIPE: "..recipe_name)
    goto skip_recipe
  end

  -- ignore science packs
  for _, result in ipairs(util.get_normalized_recipe_results(recipe_name, for_expensive_mode)) do
    if item_ranking.item_data[result.name] and item_ranking.item_data[result.name].is_science then
      -- log("SKIPPING RECIPE (science pack): "..recipe_name)
      goto skip_recipe
    end
  end

  -- find the recipe and account for expensive/normal mode split
  if for_expensive_mode and recipe.expensive then
    recipe = recipe.expensive
  elseif recipe.normal then
    recipe = recipe.normal
  end

 

  -- first remove any fish from the recipe
  for i=#new_ingredients,1,-1 do
    if new_ingredients[i].name == "raw-fish" then
      --total_fish = total_fish + new_ingredients[i].amount
      -- table.insert(removed_ingredients, new_ingredients[i])
      -- table.remove(flippable_indexes, i)
      table.remove(new_ingredients, i)
    end
  end

  -- exclude fluids and weird ingredients

  for index, ingr in ipairs(new_ingredients) do
    if not (ingr.catalyst_amount or ingr.probability) then -- ingr.type == "fluid" or 
      table.insert(flippable_indexes, index)
    end
  end
--log("flippable indexes: " .. #flippable_indexes)
  if #flippable_indexes <= 1 then
    -- log("SKIPPING RECIPE (not enough flippable ingredients): ".. recipe_name)
    goto skip_recipe
  end

  do
  -- print(recipe_name, #flippable_indexes)

  -- local should_flip_by_index = {}

  -- flip the chosen results, record removed ingredients

  -- choose a random index from the list of flippable indexes
  util.seed_rng(settings.startup["fishblock-seed"].value, recipe_name)
  local index_to_flip = flippable_indexes[util.randint(#flippable_indexes)]
  -- log("FLIPPABLE INGREDIENTS FOR "..recipe_name..": "..dump(flippable_indexes))
  -- log("FLIPPING INDEX "..index_to_flip.." FOR "..recipe_name)
  -- add the chosen ingredient to the total fish count
  

--log("Iteration is: ".. iterator .. "  Item is:" .. inspect({new_ingredients[index_to_flip]}))
    total_fish = math.max(1, get_ingredients_total_value({new_ingredients[index_to_flip]}, recipe_name))

  -- remove the chosen ingredient from the modified recipe
  table.insert(removed_ingredients, new_ingredients[index_to_flip])
  table.remove(new_ingredients, index_to_flip)

  -- add an appropriate number of fish as ingredients to the modified recipe
  if total_fish > 0 then
    local num_fish = math.min(65535, math.ceil(total_fish))
    table.insert(new_ingredients, {name="raw-fish", amount=num_fish})
  end


  -- -- set this recipe as the canonical recipe for the item -- TODO: this is a bit of a hack
  -- local results = util.get_normalized_recipe_results(recipe_name)
  -- if #results == 1 then
  --   local data = item_ranking.item_data[results[1].name]
  --   if data then
  --     data.canonical_recipe = recipe_name
  --   end
  -- end
  returnthis = {new_ingredients, removed_ingredients}
end

  ::skip_recipe::
  return returnthis
end


-- replace ingredients with fish
local removed_ingredients_by_recipe = {}
local new_ingredients_by_recipe = {}
local iterator = 0
for _, recipe_name in ipairs(item_ranking.accessible_recipes) do
  local r = fishify_recipe(recipe_name, false, iterator) -- normal mode
  if r ~= nil then
    new_ingredients_by_recipe[recipe_name] = r[1]
    removed_ingredients_by_recipe[recipe_name] = r[2]
  end
  iterator = iterator + 1
  -- elseif new_ingredients_by_recipe[recipe_name] == nil then
  --   new_ingredients_by_recipe[recipe_name] = util.get_normalized_recipe_ingredients(recipe_name, false)
  --   removed_ingredients_by_recipe[recipe_name] = {}
  -- end
end

for recipe_name, new_ingredients in pairs(new_ingredients_by_recipe) do
  local recipe = data.raw.recipe[recipe_name]
  if recipe.normal then
    recipe = recipe.normal
  end

  recipe.ingredients = new_ingredients
end


local ignore_items = {
  -- ["landfill"]=true,
  -- ["used-up-uranium-fuel-cell"]=true,
  ["space-science-pack"]=true
}

-- create unassemble recipes
local unassemble_recipes = {}

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

    local new_result = make_unassemble_result(ingr.name, result_amount, result_chance)



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
  local new_recipe = construct_liquidate_recipe(item_name, i)
  i = i+1
  -- whitelist for productivity modules
  for _, module in pairs(data.raw.module) do
    if module.category == "productivity" and module.limitation then
      table.insert(module.limitation, new_recipe.name)
      log("added "..new_recipe.name.." to "..module.name)
    end
  end

  table.insert(new_recipe.results, make_unassemble_result("raw-fish", num_fish, 1))
  new_recipe.energy_required = (0.1 * item_value)
  table.insert(unassemble_recipes, new_recipe)
  log("Liquidate Recipe data for " .. new_recipe.name .. " is: " .. inspect(new_recipe))
  ::continue::
end

-- add fish as an ingredient to each science pack
for item_name, item_data in pairs(item_ranking.item_data) do
  if item_data.is_science and item_data.value ~= nil then
    local recipe = data.raw.recipe[item_name]
    if recipe and recipe.ingredients then
      -- local base_cost = item_data.cumulative_complexity * settings.startup["science-pack-fish"].value
      local base_cost = item_data.value --* (item_data.made_in_batch_of_size)
      local x = 1 --+ (item_data.tech_level)
      x = x * (recipe.result_count or 1)
      local cost = math.ceil(x * base_cost)

      --log("Item name is: " .. inspect(item_name) .. "\nItem cost is: " .. inspect(cost))
      
      -- add the fish
      fish_ingredients = denominate_fish(cost)
      for _, fish_ingredient in ipairs(fish_ingredients) do
        table.insert(recipe.ingredients, fish_ingredient)
      end
      -- table.insert(recipe.ingredients, {"raw-fish", cost})
    end
  end
end

local golden_fish_icons = {
  {
    icon = "__base__/graphics/icons/fish.png",
    icon_size = 64,
  },
  {
    icon = "__fishmode_plus__/legendary.png",
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
-- -- recipe for golden fish
-- local golden_fish_recipe = {
--   type = "recipe",
--   name = "legendary-fish",
--   category = "crafting",
--   subgroup = "fish-winning",
--   order = "a-a-a",
--   icons = golden_fish_icons,
--   icon_size = 64,
--   -- localised_name = {"legendary-fish"},

--   ingredients = {
--     -- {"very-many-fish", 65535},
--     {"raw-fish", 65535},
--   },
--   results = {
--     {
--       name = "legendary-fish",
--       amount = 1,
--       probability = 1/(10000),
--     }
--   },
--   main_product = "",
--   -- result = "legendary-fish",

--   icon_size = 64,
--   energy_required = 42,
--   -- allow_as_intermediate = false,
--   -- allow_intermediates = false,
--   allow_decomposition = false,
--   enabled = false,
-- }

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

-- determine what can be gathered from fish
data.raw["fish"]["fish"].minable.results = {
  make_unassemble_result("raw-fish", 5, 1.0),
  make_unassemble_result("raw-fish", 94, 0.01),
}

-- add a small chance to fish up random items
local fishable_items = {}


function add_fish_minable_result(item_name, amount, probability)
  table.insert(data.raw["fish"]["fish"].minable.results, make_unassemble_result(item_name, amount, probability))
end

add_fish_minable_result("automation-science-pack", 1, 1)
add_fish_minable_result("logistic-science-pack", 1, 0.25)
add_fish_minable_result("military-science-pack", 1, 0.05)
add_fish_minable_result("chemical-science-pack", 1, 0.05)
add_fish_minable_result("production-science-pack", 1, 0.01)
add_fish_minable_result("utility-science-pack", 1, 0.01)

data:extend(unassemble_recipes)

-- create the groups and subgroups for our recipes
data:extend({
  {
    name="fishy-recipe", type="item-group",
    icons = {
      {
        icon = "__base__/graphics/icons/fish.png",
        -- size = 64,
        tint = {r=0.9, g=0.6, b=0.3, a=1},
      }
    },
    icon_size = 64,
    order="z-a"
  },

  {name="fishy-unassemble", group="fishy-recipe", type="item-subgroup", order="c"},
  {name="fishy-liquidate", group="fishy-recipe", type="item-subgroup", order="a"},
  {name="fish-processing", group="fishy-recipe", type="item-subgroup", order="b"},
  {name="fish-winning", group="fishy-recipe", type="item-subgroup", order="z"},
  {name="fishy-liquidate", type="recipe-category"}
})

if not settings.startup["use-normal-mapgen"].value then
  mapgen.modify_mapgen()
end

require("description")