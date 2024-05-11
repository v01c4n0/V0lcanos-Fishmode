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


    --item-description.liquidate-multiplier

    --[[[[[[[[[[[[[[[[[[[[
        if settings.startup["visible-liquidate-multiplier"].value then
    for _, prototype in pairs(data.raw) do
        for item_name, item in pairs(prototype) do
            local blah = 0
            if item_ranking.item_data[item_name] and item_ranking.item_data[item_name].value_mult and not item_ranking.item_data[item_name].is_science then
                --item.localised_description = {item_ranking.item_data[item_name].value_mult}
                --log(item_ranking.item_data[item_name].value_mult)
                --local string =  ({"description.liquidate-multiplier"} .. math.floor((item_ranking.item_data[item_name].value_mult+0.5)*100)/100)
            --[[
            if item.localised_description and item.localised_description ~= '' then
                item.localised_description = {'', item.localised_description, '\n', {"item-description.liquidate-multiplier", tostring((math.floor((item_ranking.item_data[item_name].value_mult+0.5)*100)/100 .. "x"))}}
                    return
            end
            
                item.localised_description =
                {
                "?",
                {" ", {"item-description.", item_name}, "\n", {"item-description.liquidate-multiplier", tostring((math.floor((item_ranking.item_data[item_name].value_mult+0.5)*100)/100)) .. "x"}},
                {"description.liquidate-multiplier", tostring((math.floor((item_ranking.item_data[item_name].value_mult+0.5)*100)/100)) .. "x"}
    
                }

               --print(item_name)
               if _ == "item" or _ == "item-group" or _ == "item-with-entity-data" or _ == "item-with-inventory" or _ == "item-with-label" or _ == "item-with-tags" then
                blah = 1
                if item.localised_description == "" then
                    item.localised_description = {"description.liquidate-multiplier", tostring(math.floor((item_ranking.item_data[item_name].value_mult+0.5)*100)/100)}
                else 
                    item.localised_description = {'', item.localised_description, '\n', {"item-description.liquidate-multiplier", tostring(math.floor((item_ranking.item_data[item_name].value_mult+0.5)*100)/100)}}
                end
               item_ranking.item_data[item_name].description = true
               log(tostring(math.floor((item_ranking.item_data[item_name].value_mult+0.5)*100)/100))
               log(inspect(item.localised_description))
               log(item_name)
            end
    
  
                --item.localised_description = string
            --log({"item-description.liquidate-multiplier"})
                --item.localised_description = math.floor((item_ranking.item_data[item_name].value_mult+0.5)*100)/100
            end
            if item.localised_description == "" then
                item.localised_description = {"item-description.liquidate-multiplier", 1}
            else if blah == 0 then
                item.localised_description = 
                {
                    "",
                    item.localised_description, "\n",
                    {"item-description.liquidate-multiplier", 1}
                }
            end
            end
        end
    end
end
--]]