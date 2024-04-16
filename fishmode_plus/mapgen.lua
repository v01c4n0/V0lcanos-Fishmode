local noise = require("noise")
local tne = noise.to_noise_expression

-- local dnf = noise.define_noise_function


local M = {}

local reduction_factor = 1.5
local function process_expression(expr)
  -- print(expr)
  if type(expr) == "table" then
    if expr.type == "variable" and expr.variable_name:match("^control%-setting:([^:]+):size:multiplier$") then
      -- print("===== Found control-setting: " .. expr.variable_name)
      return {
        type = "function-application",
        function_name = "multiply",
        arguments = {
          expr,
          {
            type = "literal-number",
            literal_value = 1.0/reduction_factor
          }
        }
      }
    else
      for k, v in pairs(expr) do
        expr[k] = process_expression(v)
      end
    end
  end
  return expr
end

function reduce_resource_patch_size(resource_table)
  if resource_table.autoplace then
    process_expression(resource_table.autoplace.probability_expression)
  end
  -- process_expression(resource_table.autoplace.richness_expression)
end

M.modify_mapgen = function()
  print("===== Modifying mapgen")

  for _, resource in pairs(data.raw["resource"]) do
    reduce_resource_patch_size(resource)
  end
end



return M