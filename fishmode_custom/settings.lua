data:extend({
  {
    type = "int-setting",
    name = "fishblock-seed",
    minimum_value = 0,
    maximum_value = 1048576,
    setting_type = "startup",
    default_value = 1234,
  },
  --[[ 
  {
  type = "double-setting",
  name = "fish-cost-multiplier",
  minimum_value = 0,
  maximum_value = 100,
  setting_type = "startup",
  default_value = 1,
  },
  --]] 
  --[[ 
  {
  type = "double-setting",
  name = "fish-result-multiplier",
  minimum_value = 0,
  maximum_value = 100,
  setting_type = "startup",
  default_value = 1,
 },  
 --]]
  {
    type = "bool-setting",
    name = "use-normal-mapgen",
    setting_type = "startup",
    default_value = false,
  },
  --[[ {
  type = "int-setting",
  name = "science-pack-fish",
  minimum_value = 0,
  maximum_value = 100,
  setting_type = "startup",
  default_value = 5,
},
  --]]
   {
    type = "int-setting",
    name = "asssembly-machine-power-consumption",
    minimum_value = 1,
    maximum_value = 100,
    setting_type = "startup",
    default_value = 2,
    },
})