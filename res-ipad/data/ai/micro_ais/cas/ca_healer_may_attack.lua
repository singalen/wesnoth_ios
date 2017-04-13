local H = wesnoth.require "lua/helper.lua"
local W = H.set_wml_action_metatable {}

local ca_healer_may_attack = {}

function ca_healer_may_attack:evaluation()
    -- After attacks by all other units are done, reset things so that healers can attack, if desired
    -- This will be blacklisted after first execution each turn

    local score = 99900
    return score
end

function ca_healer_may_attack:execution(cfg, data)
    W.modify_ai {
        side = wesnoth.current.side,
        action = "try_delete",
        path = "aspect[attacks].facet[no_healers_attack]"
    }

    -- Once combat (by other units) is done, set the healer move score so that it
    -- now happens before combat (of the healers which were so far excluded from combat)
    data.HS_healer_move_score = nil
end

return ca_healer_may_attack