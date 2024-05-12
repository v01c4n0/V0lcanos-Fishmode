-- determine what can be gathered from fish
data.raw["fish"]["fish"].minable.results = {
    util.make_unassemble_result("raw-fish", 5, 1.0),
    util.make_unassemble_result("raw-fish", 94, 0.01),
  }
  
  function add_fish_minable_result(item_name, amount, probability)
    table.insert(data.raw["fish"]["fish"].minable.results, util.make_unassemble_result(item_name, amount, probability))
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