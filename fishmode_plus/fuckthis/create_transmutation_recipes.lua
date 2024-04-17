local energy_required_for_unassemble_recipes = 3

function denominate_fish(number)
  -- Calculate the number of k^2 factors
  assert(number < 65536, "number of fish is too large")
  return {
    {name="raw-fish", amount=number, type="item"}
  }
end


local unrecipes = {}



local function construct_unassemble_recipe(item_name, produced_item_name)
  -- local item_data = item_ranking.item_data[item_name]
  -- icon for our new recipe
  local icons = util.get_item_icon(item_name)
  -- local canonical_recipe = item_ranking.item_data[item_name].canonical_recipe
  if not icons then
    icons = { "__base__/graphics/icons/signal/signal_X.png" }
  end

  for _, icon in ipairs(icons) do
      if not icon.icon_size then
        icon.icon_size = 64
      end
  end
  -- icons[1].scale = {-0.5, 0.5}
  -- icons[1].shift = {2, 2}
  -- icons[1].tint = {r = 1.0, g = 0.8, b = 0.8, a = 1}
  icons[1].scale = 0.42
  table.insert(icons, 1, {
    icon = "__base__/graphics/icons/deconstruction-planner.png",
    icon_size = 64,
    -- scale = 0.5,
    -- shift = {-10, -10},
    tint = {r=0.45, g=0.45, b=0.45, a=1}
  })
  
  local extra_icon = util.get_item_icon(produced_item_name)[1]
  if extra_icon then
    -- extra_icon.icon_size = 64
    extra_icon.scale = 0.30
    extra_icon.shift = {10, -16}
    -- extra_icon.tint = {r=0.9, g=0.9, b=0.9, a=1}
    table.insert(icons, 2, extra_icon)
  end

 -- log(item_name)
  item_localised_name = {"?",
    {"item-name."..item_name},
    {"entity-name."..item_name},
    {"entity-name."..item_name},
    {"equipment-name."..item_name},
  }

  local function order_string(order_for_item_with_name)
    local item_proto = util.get_item_prototype(order_for_item_with_name)
    if item_proto then
      return (item_proto.group or "z") .. "-" .. (item_proto.subgroup or "z") .. "-" .. (item_proto.order or "z")
    else
      return "z-z-z"
    end
  end

  local new_recipe = {
    category = "crafting",
    name = "unassemble-"..item_name,
    localised_name = {"fishy-unassemble", item_localised_name},
    order = order_string(produced_item_name) .. "-" .. order_string(item_name),
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

local function construct_liquidate_recipe(item_name)
  local icons = util.get_item_icon(item_name)
  if not icons then
    icons = { "__base__/graphics/icons/signal/signal_X.png" }
  end

  for _, icon in ipairs(icons) do
    if not icon.icon_size then
      icon.icon_size = 64
    end
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
    order = item_name,
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
    -- order = "z-", -- TODO sort by something
    type = "recipe",
    energy_required = 5,
    allow_as_intermediate = false,
    allow_intermediates = false,
    enabled = true,
    hide_from_player_crafting = true,
  }
  return new_recipe
end



function get_ingredients_total_value(ingredients)
    local value_of_fish = 1
  local total = 0
  for _, ingr in ipairs(ingredients) do
    local item_data = item_ranking.item_data[ingr.name]
    if item_data then
      total = total + (item_ranking.item_data[ingr.name].value * ingr.amount)
    end
  end
  return total / value_of_fish
end






-- replace ingredients with fish
local removed_ingredients_by_recipe = {}
local new_ingredients_by_recipe = {}
for _, recipe_name in ipairs(item_ranking.accessible_recipes) do
  local r = fishify_recipe(recipe_name, false) -- normal mode
  if r ~= nil then
    new_ingredients_by_recipe[recipe_name] = r[1]
    removed_ingredients_by_recipe[recipe_name] = r[2]
  end
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
    if result_chance <= 0.01 then
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
      for i=1, #util.get_normalized_recipe_ingredients(item_recipe) - 1 do
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

--please 
log(inspect(item_ranking.item_data))

-- create liquidate recipes
for item_name, item_data in pairs(item_ranking.item_data) do
  -- local canonical_recipe = item_data.canonical_recipe

  --please help me i have NO CLUE why item name is a table value fuck fuck fuck
  --okay it turns out the problem was caused by the recipe definitions in data.lua using result = {{item name, item amount}} instead of results
  --the debug tool helped me find the problem quickly thank you stack exchange
  log(inspect(item_name))

  local item_value = item_data.value

  local value_mult = 1.0 - (1/2) ^ item_data.complexity

  local base = item_data.cumulative_complexity / item_data.made_in_batch_of_size
  local num_fish = base + item_value * value_mult
  num_fish = math.min(65535, num_fish)

  local fish_chance = 1.0

  if item_data.is_fluid or ignore_items[item_name] then
    goto continue
  end
  if item_value == 0 or item_value == math.huge or item_name == "raw-fish" then
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

  table.insert(new_recipe.results, make_unassemble_result("raw-fish", num_fish, 1))
  table.insert(unassemble_recipes, new_recipe)
  ::continue::
end

-- add fish as an ingredient to each science pack
for item_name, item_data in pairs(item_ranking.item_data) do
  if item_data.is_science and item_data.value ~= math.huge then
    local recipe = data.raw.recipe[item_name]
    if recipe and recipe.ingredients then
      -- local base_cost = item_data.cumulative_complexity * settings.startup["science-pack-fish"].value
      local base_cost = item_data.value
      local x = 1 + (item_data.tech_level)
      x = x * (recipe.result_count or 1)
      local cost = math.ceil(x * base_cost)
      
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



-- determine what can be gathered from fish
data.raw["fish"]["fish"].minable.results = {
  make_unassemble_result("raw-fish", 5, 1.0),
  make_unassemble_result("raw-fish", 94, 0.01),
}



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

