/// SCRIPT_BATTLE_END(_victory)
function SCRIPT_BATTLE_END(_victory) {
    global.in_battle = false;
    global.__battle_player_spawned = false; // if you used the singleton flag

    // --- Capture battle HP (safe, even if stats missing)
    var _hp     = 30;
    var _hp_max = 30;

    if (instance_exists(global.player)) {
        if (variable_instance_exists(global.player, "stats")) {
            var _st = global.player.stats;
            if (is_struct(_st)) {
                if (variable_struct_exists(_st, "hp"))     _hp     = _st.hp;
                if (variable_struct_exists(_st, "hp_max")) _hp_max = _st.hp_max;
            }
        }
    }

    // --- Where to return (saved when you entered battle)
    var _ret_room = room;
    var _ret_x    = 0;
    var _ret_y    = 0;

    if (!is_undefined(global.battle) && is_struct(global.battle.return_info)) {
        _ret_room = global.battle.return_info.room;
        _ret_x    = global.battle.return_info.x;
        _ret_y    = global.battle.return_info.y;
    }

    // --- Store payload for overworld restore
    global.return_after_battle = {
        room:   _ret_room,
        x:      _ret_x,
        y:      _ret_y,
        hp:     _hp,
        hp_max: _hp_max
    };

    // --- Clean up battle player (destroy AFTER reading stats)
    if (instance_exists(global.player)) with (global.player) instance_destroy();

    // --- Optional: clear battle package now
    // global.battle = undefined;

    // Instant exit to overworld
    room_goto(_ret_room);
}
