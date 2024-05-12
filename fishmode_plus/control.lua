-- local n = settings.startup["multiplier"].value
-- 
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

function onPlayerJoined(event)
  local player = game.get_player(event.player_index)
  initPlayer(player)
end

local function enable_recipe(force, recipe_name)
  if force.recipes[recipe_name] then
    force.recipes[recipe_name].enabled = true
  end
end

-- local function unhide_recipe(force, recipe_name)
--   if force.recipes[recipe_name] then
--     force.recipes[recipe_name].hidden = false
--   end
-- end

local function add_recipes_from_items_in_inventory(player_index)
  for _, inv in ipairs({
    defines.inventory.character_main,
    defines.inventory.character_guns,
    defines.inventory.character_ammo,
    defines.inventory.character_armor,
    defines.inventory.character_vehicle,
    defines.inventory.character_trash
  }) do
    local player = game.players[player_index]
    selected_inventory = player.get_inventory(inv)
    if selected_inventory then
      local contents = selected_inventory.get_contents()
      for item_name, item_count in pairs(contents) do
        enable_recipe(player.force, "unassemble-"..item_name) -- TODO: also use production stats to unlock these (or maybe not?)
      end
    end
  end
end

script.on_event({
  defines.events.on_player_main_inventory_changed,
  defines.events.on_player_gun_inventory_changed,
  defines.events.on_player_armor_inventory_changed,
  defines.events.on_player_ammo_inventory_changed,
  defines.events.on_player_trash_inventory_changed
}, function(e)
  add_recipes_from_items_in_inventory(e.player_index)
end)

script.on_init(function()
  if remote.interfaces["freeplay"] then
    -- remote.call("freeplay", "set_custom_intro_message", "Happy fishing!")
  end
end)

script.on_event(defines.events.on_built_entity,function(event)
  if event.created_entity.name == "liquidator" then
    event.created_entity.destructible = false
  end
  end)

local function unlock_unassemble_recipes_from_research(force, research_name)
  for _, effect in ipairs(force.technologies[research_name].effects) do
      if effect.type == "unlock-recipe" then
          local recipe_name = effect.recipe
          local recipe = force.recipes[recipe_name]
          if recipe then
              for _, product in ipairs(recipe.products) do
                  if product.type == "item" then
                      enable_recipe(force, "unassemble-" .. product.name)
                  end
              end
          end
      end
  end
end

script.on_event(defines.events.on_research_finished, function(event)
  local research = event.research
  local force = research.force
  unlock_unassemble_recipes_from_research(force, research.name)
end)

function unlock_proper_unassemble_recipe_for_force(force)
  for _, tech in pairs(force.technologies) do
    if tech.researched then
      unlock_unassemble_recipes_from_research(force, tech.name)
    end
  end

  for _, recipe in pairs(force.recipes) do
    if recipe.enabled then
      for _, product in pairs(recipe.products) do
        if product.type == "item" then
          enable_recipe(force, "unassemble-" .. product.name)
        end
      end
    end
  end
end

script.on_event(defines.events.on_force_created, function(event)
  unlock_proper_unassemble_recipe_for_force(event.force)
end)

script.on_event(defines.events.on_player_created, function(event)
  local player = game.get_player(event.player_index)
  if player then
  unlock_proper_unassemble_recipe_for_force(player.force)
  end
end)



script.on_configuration_changed(
  function()
    for _, surface in pairs(game.surfaces) do
      for _, entity in pairs(surface.find_entities_filtered{name ="liquidator"}) do
        entity.destructible = false
      end
    end
end)

