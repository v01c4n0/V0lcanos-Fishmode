data:extend({
  {
    type = "int-setting",
    name = "fishblock-seed",
    minimum_value = 0,
    maximum_value = 1048576,
    setting_type = "startup",
    default_value = 1234,
  },
  {
    type = "bool-setting",
    name = "use-normal-mapgen",
    setting_type = "startup",
    default_value = false,
  },
{
  type = "double-setting",
  name = "assembling-machine-pollution-multiplier",
  minimum_value = 1,
  maximum_value = 100,
  setting_type = "startup",
  default_value = 2,
  },
{
  type = "double-setting",
  name = "fish-value-multiplier",
  minimum_value = 0,
  maximum_value = 10,
  setting_type = "startup",
  default_value = 1/4,
  },
{
  type = "bool-setting",
  name = "visible-liquidate-multiplier",
  setting_type = "startup",
  default_value = true
}
})