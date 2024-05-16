--library for creating human readable outputs from any value, including nested tables
--if you want to view what the fuck is going wrong with a value write log(inspect(value))
inspect = require("lib/inspect")
--flib utilities
--flib = require("__flib__")
-- utilities
util = require("lib/util")
--Reduces ores in mapgeneration
mapgen = require("scripts/mapgen")
--Ranks the item by their fish value
item_ranking = require("scripts/item-ranking")
--Currently really bloated. Creates transmutation recipes, recycling recipes, adds science to fish, and 
require("scripts/fish/fish")
--Adds fish to science packs
require("scripts/science")
--Adds description line for complexity
require("scripts/description")





