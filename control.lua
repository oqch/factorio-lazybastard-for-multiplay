local handler = require("event_handler")

local mod = {}

local function give_necessry_items(player)
    if not player.get_main_inventory() then return end
    player.insert{ name = "solar-panel", count = 32 }
    player.insert{ name = "accumulator", count = 8 }
    player.insert{ name = "substation", count = 1 }
    player.insert{ name = "assembling-machine-1", count = 1 }
    player.insert{ name = "small-electric-pole", count = 2 }
end

local function enable_crafting(event)
    for _, player in pairs(game.players) do
        player.force.manual_crafting_speed_modifier = 1
    end
end

local function disable_crafting(e)
    game.players[e.player_index].force.manual_crafting_speed_modifier = -1
end

local function main(e)
    if  global.rocket_lauched then return end
    disable_crafting(e)
    local player = game.players[e.player_index]
    give_necessry_items(player)
end

local function player_created(e)
    main(e)
end

local function cutscene_cancelled(e)
    if remote.interfaces["freeplay"] then
        main(e)
    end
end

local function rocket_launched(event)
    global.rocket_lauched = true
    enable_crafting(event)
end

mod.events = {
    [defines.events.on_player_created] = player_created,
    [defines.events.on_cutscene_cancelled] = cutscene_cancelled,
    [defines.events.on_rocket_launched] = rocket_launched
}

mod.on_init = function()
    global.rocket_lauched = false
end

handler.add_lib(mod)
