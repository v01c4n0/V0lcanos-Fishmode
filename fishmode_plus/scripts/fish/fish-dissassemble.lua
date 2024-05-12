
local energy_required_for_unassemble_recipes = 3

function denominate_fish(number)
  -- Calculate the number of k^2 factors
  assert(number < 65536, "number of fish is too large")
  return {
    {name="raw-fish", amount=number, type="item"}
  }
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


function fishify_recipe(recipe_name, for_expensive_mode, iterator)
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

local sortString = ""
function construct_unassemble_recipe(item_name, produced_item_name)

  local icons = util.get_item_icon(item_name)
  if not icons then
    icons = {{icon ="__base__/graphics/icons/signal/signal_X.png", icon_size = 64}}
  end
  --changes scale to 0.8 the original
  if icons[1].scale then icons[1].scale =  icons[1].scale * 0.8 else icons[1].scale = 0.35 end
  icons[3] = icons[1]

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

  sortString = ""
  local sortValueProducedItemCost = 0
  local sortValueItemCost = 0

  if item_ranking.item_data[produced_item_name].value then sortValueProducedItemCost = math.floor(item_ranking.item_data[produced_item_name].value*100) end
  for p = 5, 0, -1 do
    sortString = sortString .. string.char(97+math.fmod(math.floor(sortValueProducedItemCost/26^p), 26))
  end
  sortString = sortString .. produced_item_name
  --log("Produced Item Value is: " .. sortValueProducedItemCost)
  if item_ranking.item_data[item_name].value then sortValueItemCost = math.floor(item_ranking.item_data[item_name].value*100) end
  --log("Deconstructed Item Value is: " .. sortValueItemCost)
  for p = 5, 0, -1 do
    sortString = sortString .. string.char(97+math.fmod(math.floor((sortValueItemCost/26^p)), 26))
  end
  --log("Order field is: " .. sortString)
  --log("Produced Item name is: ".. produced_item_name .. "\nDeconstructed item name is: ".. item_name)



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

-- replace ingredients with fish
removed_ingredients_by_recipe = {}
new_ingredients_by_recipe = {}
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
