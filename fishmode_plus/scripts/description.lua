local allowed_categories = {"item", "item-with-entity-data", "armor", "capsule", "rail-planner", "rail-chain-signal", "rail-signal", "ammo", "ammo-turret", "item-with-inventory", "item-with-label", "item-with-tags", "gun"}

if settings.startup["visible-liquidate-multiplier"].value then
    for category, prototype in pairs(data.raw) do
        for item_name, item in pairs(prototype) do
            for _, allowed in pairs(allowed_categories) do
                if allowed == category then
                    if item_ranking.item_data[item.name] then
                        if item_ranking.item_data[item.name].value_mult then
                            local digit1 = tostring(math.floor(item_ranking.item_data[item_name].value_mult))
                            local digit2 = tostring(math.fmod(math.floor(item_ranking.item_data[item_name].value_mult*10), 10))
                            local digit3 = tostring(math.fmod(math.fmod(math.floor(item_ranking.item_data[item_name].value_mult*100), 100), 10))
                            if (not (digit1 or digit2 or digit3)) then
                                digit1 = "1"
                                digit2 = "0"
                                digit3 = "0"
                            end
                            digit1 = digit1 .. "."
                            digit1 = digit1 .. digit2 .. digit3
                            if (item.localised_description ~= "") and (item.localised_description ~= {}) and (item.localised_description ~= nil) then
                                item.localised_description = {
                                    "",
                                    item.localised_description, "\n",
                                    {"rescription-liquidate-multiplier", digit1}
                                }
                            else
                                item.localised_description = {"rescription-liquidate-multiplier", digit1}
                            end
                            log(item_name)
                            log("why")
                            log(digit1)
                            --print(digit2)
                            --(digit3)
                            log(inspect(item.localised_description))

                        end
                    end
                end
            end
        end
    end
end