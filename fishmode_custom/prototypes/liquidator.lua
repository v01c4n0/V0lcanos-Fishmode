local noise = require("noise")
local tne = noise.to_noise_expression
local litexp = noise.literal_expression

function basis_noise(inverse_input_scale, output_scale)
  return tne{
    type = "function-application",
    function_name = "factorio-basis-noise",
    arguments = {
      x = noise.var("x"),
      y = noise.var("y"),
      seed0 = tne(noise.var("map_seed")),
      seed1 = tne(123),
      input_scale = tne(1/inverse_input_scale),
      output_scale = tne(output_scale)
    }
  }
end

local function spots()
  local base_density = 20
  local spot_quantity = 10000
  local spot_radius = 15
  
  -- local basement_value = -6 * spot_quantity^(1/3) / spot_radius^2
  
  local spots = tne{
    type = "function-application",
    function_name = "spot-noise",
    arguments = {
      x = noise.var("x"),
      y = noise.var("y"),
      seed0 = noise.var("map_seed"),
      seed1 = tne(12345),
      region_size = tne(1024),
      candidate_spot_count = tne(21),
      density_expression = litexp(base_density),--litexp(liquidator_basis_noise(100, 10)),
      spot_quantity_expression = litexp(spot_quantity),
      spot_radius_expression = litexp(spot_radius),
      spot_favorability_expression = litexp(1),
      basement_value = tne(-1),
      maximum_spot_basement_radius = tne(128)
    }
  }
  
  return spots
end

local icon_tint = {r = 0.8, g = 0.6, b = 1.0, a = 1}
local sprite_tint = {r = 0.6, g = 0.4, b = 1.0, a = 1}

data:extend({{
  -- copied from market prototype
  allow_access_to_all_forces = true,
  collision_box = {
    {
      -1.3999999999999999,
      -1.3999999999999999
    },
    {
      1.3999999999999999,
      1.3999999999999999
    }
  },
  is_military_target = false,
  corpse = "big-remnants",
  damaged_trigger_effect = {
    damage_type_filters = "fire",
    entity_name = "spark-explosion",
    offset_deviation = {
      {
        -0.5,
        -0.5
      },
      {
        0.5,
        0.5
      }
    },
    offsets = {
      {
        0,
        1
      }
    },
    type = "create-entity"
  },
  flags = {
    "placeable-player",
    -- "player-creation",
    "not-blueprintable",
    "not-deconstructable",
    "hidden"
  },
  tint = {r = 0.4, g = 0.4, b = 1.0},
  --TODO: create better liquidator asset using paint.NET or other editing software
  icon = "__fishmode_custom__/liquidator-icon.png",
  scale = 0.4,
  icon_mipmaps = 4,
  icon_size = 64,
  max_health = 1500,
  name = "liquidator",
  open_sound =  data.raw.accumulator.accumulator.open_sound,
  close_sound = data.raw.accumulator.accumulator.close_sound,
  order = "d-a-a",
  animation = {
    filename = "__fishmode_custom__/liquidator.png",
    height = 396, --127
    shift = {
      0.2,
      0.4
    },
    width = 410,
    scale = 0.325
  },
  selection_box = {
    {
      -1.5,
      -1.5
    },
    {
      1.5,
      1.5
    }
  },
  subgroup = "other",
  -- -- furnace
  type = "furnace",
  result_inventory_size = 1, -- 3
  crafting_categories = {
    "fishy-liquidate"
  },
  module_specification = {
    module_slots = 3,
  },
  allowed_effects = {
    "consumption",
    "speed",
    "productivity",
    "pollution"
  },
  crafting_speed = 1,
  source_inventory_size = 1,
  energy_source = {
    fuel_category = "fish-fuel",
    fuel_inventory_size = 1,
    type = "burner",
    emissions_per_minute = 100,
  },
  energy_usage = "1MW",
  collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
  selection_box = {{-1.3, -1.3}, {1.3, 1.3}},
  crafting_categories = {"fishy-liquidate"},
  crafting_speed = 1,
  source_inventory_size = 1,

  map_color = {r=0.4, g=0.8, b=0.6},
  minable = {
    mining_time = 3,
    results = {
      {
        name = "solar-panel",
        amount = 3,
      },
      {
        name = "raw-fish",
        amount = 1,
      },
      {
        name = "burner-mining-drill",
        amount = 9,
      },
    }
  },

  -- -- autoplace
  autoplace = {
    order = "f-i-s-h",
    force = "player",
    probability_expression = noise.define_noise_function(function(x, y, tile, map)
      local starter_radius = 100
      local starting = 1/700000 * (starter_radius - noise.min(starter_radius, tile.distance))
      local k =  1/30000
      local k2 = 1/80000
      return starting + basis_noise(10, k) + noise.max(0, ((basis_noise(50, 2) ^ 5) * k2) * basis_noise(300, 1) * basis_noise(1500, 1.25))
    end)
  }
}})

data:extend({{
  type = "item",
  name = "liquidator",
  icon = "__fishmode_custom__/liquidator-icon.png",
  icon_size = 64,
  icon_mipmaps = 4,
  subgroup = "other",
  order = "d-a-a",
  place_result = "liquidator",
  stack_size = 50
}})
data:extend({{
  type = "recipe",
  name = "liquidator",
  group = "fish-processing",
  subgroup = "fish-winning",
  enabled = true,
  energy_required = 999,
  ingredients = {
    { "raw-fish", 65535 }
  },
  results = {
    { type = "item", name = "liquidator", amount = 1 },
    { type = "item", name = "legendary-fish", amount = 1, probability = 0.0001}
  },
  main_product = "liquidator"
}})