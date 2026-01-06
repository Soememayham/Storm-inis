/// OBJ_Game -> Create
// Make a global pointer to this persistent manager
global.Game = id;

// (Optional) who the camera should follow (overworld or battle pawn)
follow_id = noone;

// Shared player model (lives across rooms)
player = {
    name: "Hero",
    level: 1,

    // core stats
    hp: 30, hp_max: 30,
    mp: 10, mp_max: 10,
    atk: 6,  def: 3,  spd: 220,   // <- spd is pixels/sec for overworld & battle

    // where to return after battle
    ow_x: 0, ow_y: 0, ow_room: noone
};

// Battle payload (what the next battle should spawn)
battle = {
    enemy_stats: undefined,  // struct with hp/hp_max/atk/def/spd (+ optional sprites)
    result: undefined        // "win" | "lose"
};

/// API: start a battle
/// Accepts EITHER (enemy_stats) OR (enemy_kind, enemy_stats) for backward-compat
function start_battle(_a, _b) {
    // 1) capture overworld position/room safely
    var p = instance_exists(OBJ_CHAR_OVERWORLD) ? instance_find(OBJ_CHAR_OVERWORLD, 0) : noone;
    if (p != noone) {
        player.ow_x = p.x;
        player.ow_y = p.y;
        player.ow_room = room;
    }

    // 2) resolve enemy stats argument
    var _enemy_stats = is_undefined(_b) ? _a : _b; // if you pass (kind, stats), we take the 2nd

    // 3) store for the battle room to use
    battle.enemy_stats = _enemy_stats;

    // 4) swap rooms
    room_goto(Room_Battle);
}

/// API: finish battle and return to saved overworld spot
function end_battle(_result) {
    battle.result = _result;
    if (player.ow_room != noone) {
        room_goto(player.ow_room);
    }
}
