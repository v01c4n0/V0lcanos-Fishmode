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
  