local util = {}

-- this rng implementation is borrowed from https://stackoverflow.com/a/20177466
local A1, A2 = 727595, 798405
local D20, D40 = 1048576, 1099511627776
local X1, X2 = 0, 1

function util.seed_rng(seed1, string_seed)
  local D20 = 2^20
  X1 = seed1 % D20
  
  local seed2 = 1
  for i = 1, #string_seed do
    local char = string.byte(string_seed, i)
    seed2 = seed2 + (char * (i - 1)) * 200 -- must be even
  end

  X2 = seed2 % D20
end

function util.rand()
    local U = X2 * A2
    local V = (X1 * A2 + X2 * A1) % D20
    V = (V * D20 + U) % D40
    X1 = math.floor(V / D20)
    X2 = V - X1 * D20
    return V / D40
end

-- generate a random number between inclusive 1 and inclusive upper
function util.randint(upper)
    return math.floor(util.rand() * upper) + 1
end


function util.round(number)
    if number == 0 then
        return 0
    end
    
    local power = 10 ^ (math.floor(math.log(number, 10)) - 1)
    local rounded = math.floor(number / power + 0.5) * power
    
    return math.min(65535, math.floor(rounded + 0.5))
end


function util.array_has_value(tb, target_val)
  for _, val in ipairs(tb) do
    if val == target_val then
      return true
    end
  end
  return false
end


function util.sort_table_by_values(tb)
  local sorted_keys = {}
  for key, _ in pairs(tb) do
    table.insert(sorted_keys, key)
  end
  table.sort(sorted_keys, function(a, b)
    return tb[a] < tb[b]
  end)
  return sorted_keys
end


function util.get_item_prototype(item_name)
  for k, v in pairs(defines.prototypes.item) do
    if data.raw[k][item_name] then
      return data.raw[k][item_name]
    end
  end
  return nil
end


--[[function util.get_item_icon(item_name)
  if data.raw.fluid[item_name] then
    return { { icon = data.raw.fluid[item_name].icon, icon_size = data.raw.fluid[item_name].icon_size or 64 } }
  end

  for k, v in pairs(defines.prototypes.item) do
    if data.raw[k][item_name] then
      local proto = data.raw[k][item_name]
      if proto.icons then
        return table.deepcopy(proto.icons)
    else
      proto.icons = {}
      proto.icons[1] = {icon = ""}
      if proto.icon_size ~= true then
        proto.icons[1].icon_size = 64
      else
        proto.icons[1].icon_size = proto.icon_size
      end
      if proto.icon ~= true then
        proto.icons[1].icon = "__core__/graphics/cancel.png"
      else
        proto.icons[1].icon = proto.icon
      end
      return proto.icons
    end
    end
  end
end--]]
function util.get_item_icon(item_name)
  --prototypesToRunThrough = {"data.raw[item_name]", "fluid"}
  if data.raw.fluid[item_name] then
      local proto = table.deepcopy(data.raw.fluid[item_name])
      if proto.icons then
        if not proto.icons[1].icon_size then
          proto.icons[1].icon_size = proto.icon_size
        end
        goto endoffunction
      else
        proto.icons = {{icon = "__core__/graphics/cancel.png", icon_size = 64}}
      if proto.icon then 
        proto.icons[1].icon = proto.icon
      else
        proto.icons[1].icon = "__core__/graphics/cancel.png"
      end
      if proto.icon_size then
        proto.icons[1].icon_size = proto.icon_size
      else
        proto.icons[1].icon_size = 64
      end
    end
    ::endoffunction::
    return table.deepcopy(proto.icons)
  end
  for k, v in pairs(defines.prototypes.item) do
    if data.raw[k][item_name] then
      local proto = table.deepcopy(data.raw[k][item_name])
      if proto.icons then
        if not proto.icons[1].icon_size then
          proto.icons[1].icon_size = proto.icon_size
        end
        goto endoffunction
      else
        proto.icons = {{icon = "__core__/graphics/cancel.png", icon_size = 64}}
      if proto.icon then 
        proto.icons[1].icon = proto.icon
      else
        proto.icons[1].icon = "__core__/graphics/cancel.png"
      end
      if proto.icon_size then
        proto.icons[1].icon_size = proto.icon_size
      else
        proto.icons[1].icon_size = 64
      end
    end
    ::endoffunction::
    return table.deepcopy(proto.icons)
  end
end
end



function util.get_item_sort_order(item_name)
  for k, v in pairs(defines.prototypes.item) do
    local proto = data.raw[k][item_name]
    if proto then
      local order = "b-"
      if proto.subgroup then
        order = order.."-"..proto.subgroup
      else
        order = order.."-z[no-subgroup]"
      end
      if proto.order then
        order = order..proto.order
      else
        order = order.."-z[no-order]"
      end
      return order
    end
  end
  return "zz-[no-proto-found]"
end

function util.get_item_stack_size(item_name)
  local stack_size = 0
  for category, _ in pairs(data.raw) do -- TODO use defines.prototypes instead
    local itemPrototype = data.raw[category][item_name]
    if itemPrototype and itemPrototype.stack_size then
      stack_size = math.max(stack_size, itemPrototype.stack_size)
    end
  end
  return stack_size
end


function util.get_normalized_recipe_ingredients(recipe_name, expensive_mode)
  local recipe = data.raw.recipe[recipe_name]
  if not recipe then
    log("could not find recipe with name: "..recipe_name)
    return {}
  end

  if expensive_mode and recipe.expensive then
    recipe = recipe.expensive
  elseif recipe.normal then
    recipe = recipe.normal
  end

  local normalized_ingredients = {}
  for _, ingredient in ipairs(recipe.ingredients) do
    if not ingredient.name then 
      table.insert(normalized_ingredients, {name=ingredient[1], amount=ingredient[2]})
    else
      table.insert(normalized_ingredients, table.deepcopy(ingredient))
    end
  end

  return normalized_ingredients
end


function util.get_normalized_recipe_results(recipe_name)
  local recipe = data.raw.recipe[recipe_name]

  if not recipe then log("could not get recipe with name: " .. recipe_name) goto skip end
  if recipe.normal then
    recipe = recipe.normal
  end

  if recipe.result then
    -- assuming "item" if there's only one result, hopefully this doesn't cause problems
    return { {["name"] = recipe.result, ["amount"] = (recipe.result_count or 1), type = "item", catalyst_amount = 0} }
  elseif recipe.results then
    r = {}
    for _, result in ipairs(recipe.results) do
      -- if result.type ~= "fluid" and not result.catalyst_amount then
        local name = result.name or result[1]
        local amount = (result.amount or result[2]) or 1
        table.insert(r, {["name"] = name, ["amount"] = amount, type = result.type, catalyst_amount = (result.catalyst_amount or 0)})
      -- end
    end
    return r
  end
  ::skip::
  return {}
end


function util.recipe_is_enabled(recipe_name)
  local recipe = data.raw.recipe[recipe_name]
  return not (recipe.enabled ~= nil and recipe.enabled == false)
end

function util.recipe_is_hidden(recipe_name)
  local recipe = data.raw.recipe[recipe_name]
  return recipe.hidden ~= nil and recipe.hidden == true
end

return util