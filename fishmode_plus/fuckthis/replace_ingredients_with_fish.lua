util = require("util")

require("prototypes.liquidator")

--
require("replace_ingredients_with_fish")

--
require("create_transmutation_recipes")

--
require("other")


-- replaces 1 item in recipe with fish
function fishify_recipe(recipe_name, for_expensive_mode)
    ingredients = util.get_normalized_recipe_ingredients(recipe_name, for_expensive_mode)
    recipe = data.raw.recipe[recipe_name]
    total_fish = 0
    new_ingredients = table.deepcopy(ingredients)
    removed_ingredients = {}
  
    ignoreRecipes(recipe_name)
    ignoreSciencePacks(recipe_name, for_expensive_mode)
    accountForNormalOrExpensiveMode(for_expensive_mode)
    -- first remove any fish from the recipe
    for i=#new_ingredients,1,-1 do
      if new_ingredients[i].name == "raw-fish" then
        total_fish = total_fish + new_ingredients[i].amount
        -- table.insert(removed_ingredients, new_ingredients[i])
        -- table.remove(flippable_indexes, i)
        table.remove(new_ingredients, i)
      end
    end
  
    chooseIngredientToReplace(recipe_name)

    -- add the chosen ingredient to the total fish count
    total_fish = total_fish + math.max(1, get_ingredients_total_value({new_ingredients[index_to_flip]}))
  
    -- remove the chosen ingredient from the modified recipe
    table.insert(removed_ingredients, new_ingredients[index_to_flip])
    table.remove(new_ingredients, index_to_flip)
  
    -- add an appropriate number of fish as ingredients to the modified recipe
    if total_fish > 0 then
      local num_fish = math.min(65535, math.ceil(total_fish))
      table.insert(new_ingredients, {name="raw-fish", amount=num_fish})
    end
  
    return {new_ingredients, removed_ingredients}
  end

-- ignores smelting recipes and blacklists recipes
function ignoreRecipes(recipe_name)
    ignore_recipe = {
        ["nuclear-fuel-reprocessing"]=true,
        -- ["uranium-processing"]=true,
        ["kovarex-enrichment-process"]=true,
        -- ["uranium-fuel-cell"]=true,
      }
        if recipe.category == "smelting" or ignore_recipe[recipe_name] then
            -- log("SKIPPING RECIPE: "..recipe_name)
            return nil
          end
end

  -- ignore science packs
  function ignoreSciencePacks(recipe_name, for_expensive_mode)
        for _, result in ipairs(util.get_normalized_recipe_results(recipe_name, for_expensive_mode)) do
            if item_ranking.item_data[result.name] and item_ranking.item_data[result.name].is_science then
              -- log("SKIPPING RECIPE (science pack): "..recipe_name)
              return nil
            end
        end
    end

    -- find the recipe and account for expensive/normal mode split
function accountForNormalOrExpensiveMode(for_expensive_mode)
    if for_expensive_mode and recipe.expensive then
        recipe = recipe.expensive
      elseif recipe.normal then
        recipe = recipe.normal
      end  
end

-- chooses which ingredient to replace, excluding fluids and weird ingredients
function chooseIngredientToReplace(recipe_name)
    local flippable_indexes = {}
    for index, ingr in ipairs(new_ingredients) do
      if not (ingr.catalyst_amount or ingr.probability) then -- ingr.type == "fluid" or 
        table.insert(flippable_indexes, index)
      end
    end
  
    if #flippable_indexes <= 1 then
      -- log("SKIPPING RECIPE (not enough flippable ingredients): ".. recipe_name)
      return nil
    end
  
    -- print(recipe_name, #flippable_indexes)
  
    -- local should_flip_by_index = {}
    local i = 1
  
    -- flip the chosen results, record removed ingredients
  
    -- choose a random index from the list of flippable indexes
    util.seed_rng(settings.startup["fishblock-seed"].value, recipe_name)
    index_to_flip = flippable_indexes[util.randint(#flippable_indexes)]
    -- log("FLIPPABLE INGREDIENTS FOR "..recipe_name..": "..dump(flippable_indexes))
    -- log("FLIPPING INDEX "..index_to_flip.." FOR "..recipe_name)
end