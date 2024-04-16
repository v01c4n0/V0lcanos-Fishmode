-- function manyfish_icon_offsets(tier)
--     if tier == 1 then
--         return {{0, 0}}
--     elseif tier == 2 then
--         return {{-3.5, 0}, {3.5, 0}}
--     elseif tier == 3 then
--         return {{-6, 0}, {-2, 0}, {2, 0}, {6, 0}}
--     end
-- end


-- function fish(tier)
--     proto = table.deepcopy(data.raw["capsule"]["raw-fish"])
    
--     assert(tier == 2 or tier == 3)
--     if tier == 2 then
--         proto.name = "many-fish"
--     elseif tier == 3 then
--         proto.name = "very-many-fish"
--     end

--     proto.localised_name = "raw fish"
--     -- local amount = math.pow(256, tier-1)
--     -- proto.localised_name = tostring(amount) .. " " .. proto.localised_name
--     if tier == 2 then
--         proto.localised_name = "Many " .. proto.localised_name
--         proto.order = "a-a-c"
--     elseif tier == 3 then
--         proto.localised_name = "Very many " .. proto.localised_name
--         proto.order = "a-a-b"
--     end
--     -- end
--     -- proto.localised_name = string.upper(string.sub(proto.localised_name, 1, 1))

--     proto.icons = {}
--     num_icons = #manyfish_icon_offsets(tier)
--     for i=1, num_icons do
--         proto.icons[#proto.icons+1] = {
--             icon = proto.icon,
--             icon_size = 64,
--             scale = 0.5,
--             shift = manyfish_icon_offsets(tier)[i],
--             tint = {r=1.0, g=1.0, b=1.0, a=1.0}
--         }
--     end

--     for i=1, num_icons-1 do
--         proto.icons[i].tint = {r=0.7, g=0.7, b=0.7, a=1.0}
--     end

--     return proto
-- end

-- function fish_recipe(tier)
--     local new_recipe = {
--         enabled = true,
--         energy_required = 1,
--         type = "recipe",
--         -- type = "crafting"
--         name = "test",
--         icons = icons,
--         subgroup = "fish-processing",
--         localised_name = {"condense-fish" .. tier},
--         allow_as_intermediate = false,
--         allow_intermediates = false,
--         allow_decomposition = false,
--         results = {},
--         main_product = "",
--         ingredients = {{name="raw-fish", amount=1, type="item"}},
--     }
--     -- locale string
--     new_recipe.localised_name = {"fish-becomes", {"item-name."..item_name}}
--     new_recipe.order = "b-b-b"
--     local result = make_fish_result(item_name, 5)
-- end

-- return {fish(2), fish(3)}