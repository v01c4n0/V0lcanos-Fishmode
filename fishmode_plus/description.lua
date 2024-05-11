if settings.startup["visible-liquidate-multiplier"] then
for _, prototype in pairs(data.raw) do
	for item_name, item in pairs(prototype) do
        if item_ranking.item_data[item_name] and item_ranking.item_data[item_name].complexity and not item_ranking.item_data[item_name].is_science then
            --item.localised_description = {item_ranking.item_data[item_name].value_mult}
            --log(item_ranking.item_data[item_name].value_mult)
            --local string =  ({"description.liquidate-multiplier"} .. math.floor((item_ranking.item_data[item_name].value_mult+0.5)*100)/100)
            --[[if item.localised_description and item.localised_description ~= '' then
                item.localised_description = {'', item.localised_description, '\n', {"item-description.liquidate-multiplier", tostring((math.floor((item_ranking.item_data[item_name].value_mult+0.5)*100)/100))}}
                return
            end
            --]]
            item.localised_description =
            {
                "?",
                {" ", {"item-description.", item_name}, "\n", {"item-description.liquidate-multiplier", tostring((math.floor((item_ranking.item_data[item_name].value_mult+0.5)*100)/100)), "x"}},
                {"item-description.liquidate-multiplier", tostring((math.floor((item_ranking.item_data[item_name].value_mult+0.5)*100)/100)), "x"}

            }
           print(item_name)

            --item.localised_description = string
            log({"item-description.liquidate-multiplier"})
            --item.localised_description = math.floor((item_ranking.item_data[item_name].value_mult+0.5)*100)/100
        end
    end
end
end
--item-description.liquidate-multiplier