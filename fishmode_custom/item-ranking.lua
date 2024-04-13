local util = require("util")
local M = {}

-- Helper for debugging purposes
function dump(o)
  if type(o) == 'table' then
     local s = '{ '
     for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump(v) .. ','
     end
     return s .. '} '
  else
     return tostring(o)
  end
end


-- declares variables for the item modifications and new fish magic recipes
local function new_item_data()
  return {
    canonical_recipe = "",
    made_in_batch_of_size = 1,
    is_base_item = false, 
    is_endpoint = true,
    value = math.huge,
    full_stack_value = 0,
    is_fluid = false,
    stack_size = 1,
    tech_level = math.huge,
    complexity = math.huge,
    cumulative_complexity = math.huge,
    builds_into = {},
    is_science = false,
  }
end

-- items that are used as ingredients in accesable (though tech tree or otherwise) recipes, but do not themselves have a recipe,
-- are "base items" and must have a value assigned to them manually
-- the unit of value is 1 fish
local time_value_per_second = 0.14
local base_items = {
  ["raw-fish"] = 1, -- this has to be 0 for now, otherwise all unassemble reciptes get fish as a result
			-- changed it to 1 to fuck around for now
	["coal"] = 1,
  ["wood"] = 0.25,
  ["iron-ore"] = 1,
  ["copper-ore"] = 1,
  ["stone"] = 0.25,
  ["uranium-ore"] = 2.0,
  ["crude-oil"] = 0.25,
  ["water"] = 0.001,  -- offshore pumps produce 1200/s water, this isn't unreasonable, this creates 1 fish per second from that much water via decrafting
  ["used-up-uranium-fuel-cell"] = 30.0, -- TODO, this item isn't being reached by the parser (because it isn't created directly by any normal recipe)
  ["uranium-235"] = 23.5,
  ["uranium-238"] = 2.35,
}
local value_scale = 1/5
time_value_per_second = time_value_per_second * value_scale
for k, v in pairs(base_items) do
  base_items[k] = v * value_scale
end

local function create_item_data_entry(item_name)
  if not M.item_data[item_name] then
    M.item_data[item_name] = new_item_data()
  end
end

-- initialize item data for each base item
M.item_data = { }
for item_name, value in pairs(base_items) do
  M.item_data[item_name] = new_item_data()
  M.item_data[item_name].value = value
  M.item_data[item_name].complexity = 0 -- base items are defined as having 0 complexity
  M.item_data[item_name].cumulative_complexity = 0
  M.item_data[item_name].is_endpoint = false
  M.item_data[item_name].tech_level = 0
  M.item_data[item_name].is_base_item = true
  if item_name == "crude-oil" or item_name == "water" then
    M.item_data[item_name].is_fluid = true
  end
end



-- construct a list of all recipe (names) that can be gained through research or are unlocked by default
M.accessible_recipes = {} 
-- look for starting recipes
for recipe_name, _ in pairs(data.raw.recipe) do
  if util.recipe_is_enabled(recipe_name) then
    table.insert(M.accessible_recipes, recipe_name)
  end
end


--
M.science_packs_by_recipe = {}
local science_pack_items = {}
-- parse the tech tree for unlockable recipes
for _, technology in pairs(data.raw.technology) do
  if not technology.effects then
    goto continue
  end

  -- count required science packs
  local required_science_packs = {}
  if technology.unit and technology.unit.ingredients then
    for _, ingredient in ipairs(technology.unit.ingredients) do
      local science_pack_name = ingredient[1] or ingredient.name
      table.insert(required_science_packs, science_pack_name)
      M.item_data[science_pack_name] = new_item_data()
      M.item_data[science_pack_name].is_science = true
    end
  end

  -- find all unlock recipe effects and add them to the list of accessible recipes
  for _, effect in ipairs(technology.effects) do
    if effect.type == "unlock-recipe" then
      local recipe_name = effect.recipe
      if data.raw.recipe[recipe_name] then
        table.insert(M.accessible_recipes, recipe_name)
      end

      -- record science packs required for the recipe
      M.science_packs_by_recipe[recipe_name] = table.deepcopy(required_science_packs)
    end
  end
  ::continue::
end

function M.get_recipe_tech_level(recipe_name)
  if not M.science_packs_by_recipe[recipe_name] then
    return 0
  else
    return #M.science_packs_by_recipe[recipe_name]
  end
end


-- -- DEBUG PRINT PACKS BY RECIPE
-- for recipe_name, packs in pairs(M.science_packs_by_recipe) do
--   print(recipe_name, dump(packs))
-- end


-- helper for accessing item data




--modifies the recipe costs to the appropriate amount of fish

local recipe_costs = {}
local function do_recipe_valuation_pass()
  local num_recipes_resolved_this_pass = 0

  for _, recipe_name in ipairs(M.accessible_recipes) do
    -- skip if we've already resolved the cost of this recipe
    if recipe_costs[recipe_name] or not data.raw.recipe[recipe_name] then
      goto skip_this_recipe
    end
  

    -- sum up the cost of each ingredient
    local total_cost = 0
    local greatest_ingredient_complexity = 0
    local sum_of_ingredient_complexity = 0
    local normalized_ingredients = util.get_normalized_recipe_ingredients(recipe_name)
    for _, ingredient in ipairs(normalized_ingredients) do
      local item_name = ingredient.name
      local item_count = ingredient.amount
      -- we can only calculate the cost of this recipe if the value of all ingredients is known
      if not (M.item_data[item_name] and M.item_data[item_name].value) then
        goto skip_this_recipe
      end

      -- all ingredients of this recipe are not endpoints (because they are at the very least an ingredient in this recipe)
      M.item_data[item_name].is_endpoint = false

      -- we want to keep track of the highest indedient complexity value to later calculate this recipe's complexity score
      greatest_ingredient_complexity = math.max(greatest_ingredient_complexity, M.item_data[item_name].complexity)
      sum_of_ingredient_complexity = sum_of_ingredient_complexity + M.item_data[item_name].complexity

      -- add the cost of this ingredient to the total
      total_cost = total_cost + M.item_data[item_name].value * item_count
    end
    -- add the estimated value of energy consumed to the total cost
    total_cost = total_cost + time_value_per_second * (data.raw.recipe[recipe_name].energy_required or 0.5)
    -- factor the complexity of ingredients into total cost
    total_cost = total_cost + sum_of_ingredient_complexity * 0.1
    -- total_cost = total_cost * (1 + (sum_of_ingredient_complexity * 0.01))

    -- debug to print item name alongside cost for easier testing
    print(item_name, "recipe cost is", total_cost)


    -- record this recipe cost
    recipe_costs[recipe_name] = total_cost

    -- update item data for each result
    local normalized_results = util.get_normalized_recipe_results(recipe_name)
    for _, result in ipairs(normalized_results) do
      create_item_data_entry(result.name)
      local iidd = M.item_data[result.name]

      local tech_level = M.get_recipe_tech_level(recipe_name)
      local should_become_canon = iidd.canonical_recipe == "" or (iidd.tech_level > tech_level and result.catalyst_amount == 0)
      should_become_canon = should_become_canon and not iidd.is_base_item

      if should_become_canon then
        iidd.value = total_cost / (result.amount * #normalized_results)
        iidd.canonical_recipe = recipe_name
        iidd.tech_level = tech_level
        iidd.cumulative_complexity = sum_of_ingredient_complexity
        iidd.is_fluid = result.type == "fluid"
        iidd.complexity = math.min(iidd.complexity, greatest_ingredient_complexity + 1)
        iidd.cumulative_complexity = math.min(iidd.cumulative_complexity, sum_of_ingredient_complexity)
        iidd.made_in_batch_of_size = result.amount
      end
    end

    -- count this recipe 
    num_recipes_resolved_this_pass = num_recipes_resolved_this_pass + 1
    ::skip_this_recipe::
  end
  return num_recipes_resolved_this_pass
end


-- we're done valuating when a pass fails to resolve any recipes
local passes_completed = 0
while true do
  -- print("PASS ".. passes_completed)
  if do_recipe_valuation_pass() == 0 then
    break
  end
  passes_completed = passes_completed + 1
end


-- use the now generated list of valid items (generated during the recipe valuation passes)
-- to go though and set some additional item data for convenience
for k, v in pairs(M.item_data) do
  v.stack_size = util.get_item_stack_size(k)
  v.full_stack_value = v.stack_size * v.value
end



print(passes_completed.." total passes completed.")

-- fix tech levels and complexity that were never updated
for item_name, data in pairs(M.item_data) do
  if data.tech_level == math.huge then
    data.tech_level = 0
  end

  if data.complexity == math.huge then
    -- print("COMPLEXITY WAS NEVER SET for "..item_name)
    data.complexity = 0
  end
end


function M.eval_rating(item_name, weights)
  local sum = 0
  -- v is the weight for item_data field k
  for k, v in pairs(weights) do
    sum = sum + v * M.item_data[item_name][k]
  end
  return sum
end

-- generate ratings for each item in item_data, using weights defined in weights as a table {key_name = weight_value}
function M.generate_ratings_for_all_items(weights, stackable_only)
  local ratings = {}

  for item_name, data in pairs(M.item_data) do
    if base_items[item_name] or data.is_fluid then
      -- print(item_name.." EXCLUDED because fluid")
      goto continue
    end
    if stackable_only and data.stack_size <= 1 then
      -- print(item_name.." EXCLUDED because not stackable")
      goto continue
    end
    ratings[item_name] = M.eval_rating(item_name, weights)
    ::continue::
  end
  return ratings
end


for _, recipe_name in ipairs(M.accessible_recipes) do --TODO should I use this data to set is_enpoint for items?
  local results = util.get_normalized_recipe_results(recipe_name)
  local ingredients = util.get_normalized_recipe_ingredients(recipe_name)
  for _, ingredient in ipairs(ingredients) do
    for _, result in ipairs(results) do
      if M.item_data[ingredient.name] then
        table.insert(M.item_data[ingredient.name].builds_into, result)
      end
    end
  end
  ::continue::
end


-- for k, v in pairs(M.item_data) do
--   print(k, v.canonical_recipe)
-- end

return M