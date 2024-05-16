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


-- create liquidate recipes
for item_name, item_data in pairs(item_ranking.item_data) do
  -- local canonical_recipe = item_data.canonical_recipe

  
  --(0.5 * item_data.value)
log("Item name is" .. inspect(item_name) .. "\nItem value is:" .. inspect(item_data.value))

local item_value = item_data.value

if item_name == "space-science-pack" then
  item_value= 0 
end

if item_data.is_fluid or ignore_items[item_name] then
  goto continue
end
if item_value == 0 or item_value == nil or item_name == "raw-fish" or item_data.is_base_item then
  goto continue
end
if string.sub(item_name, -6) == "barrel" then
  goto continue
end

local value_mult = 1
if item_data.complexity ~= nil then
  value_mult = math.max(1, math.pow(item_data.complexity, 1/3))
end
item_ranking.item_data[item_name].value_mult = value_mult

local num_fish = (item_value) * value_mult
  num_fish = math.min(65535, num_fish)

  local fish_chance = 1.0




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