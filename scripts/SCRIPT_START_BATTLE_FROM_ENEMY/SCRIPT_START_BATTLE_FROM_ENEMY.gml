/// SCRIPT_START_BATTLE_FROM_ENEMY(enemy_instance)
/// Requires overworld enemy to have: region, encounter_id, min_group, max_group
function SCRIPT_START_BATTLE_FROM_ENEMY(_enemy) {
    if (!instance_exists(_enemy)) return;

    // --- read config from the overworld enemy ---
    var _region    = variable_instance_exists(_enemy,"region")       ? _enemy.region       : "plains";
    var _enc_id    = variable_instance_exists(_enemy,"encounter_id") ? _enemy.encounter_id : 1;
    var _min_group = variable_instance_exists(_enemy,"min_group")    ? _enemy.min_group    : 1;
    var _max_group = variable_instance_exists(_enemy,"max_group")    ? _enemy.max_group    : 3;

    // --- pick battle room via region ---
    var _room = SCRIPT_BATTLE_REGION_ROOM(_region);

    // --- build enemy list from pool ---
    var _pool = SCRIPT_ENCOUNTER_POOL(_enc_id);
    var _n    = clamp(irandom_range(_min_group, _max_group), 1, 8);

    var enemy_types = array_create(_n);
    for (var i = 0; i < _n; i++) {
        enemy_types[i] = _pool[ irandom(array_length(_pool)-1) ];
    }

    // --- capture player stats (struct copy) ---
    var _pl = (is_undefined(global.player) || !instance_exists(global.player)) ? noone : global.player;
    var pl_stats_copy = undefined;
    if (_pl != noone && variable_instance_exists(_pl, "stats")) {
        // GMS 2.3+ json_parse returns structs/arrays → neat deep copy
        pl_stats_copy = json_parse(json_stringify(_pl.stats));
    }

    // --- remember where to return after battle ---
    var return_info = {
        room: room,
        x: (_pl != noone) ? _pl.x : 0,
        y: (_pl != noone) ? _pl.y : 0,
    };

    // --- stash battle payload globally ---
    global.battle = {
        region: _region,
        room: _room,
        encounter_id: _enc_id,
        enemy_types: enemy_types,
        player_stats: pl_stats_copy,
        return_info: return_info,
        seed: irandom(1_000_000)
    };

    // Optional: mark overworld enemy as defeated (we’ll rely on spawn controller to refill population)
    with (_enemy) instance_destroy();
	
	// Destroy overworld player before entering battle
if (instance_exists(global.player)) {
    with (global.player) instance_destroy();
}

    // Hard cut transition (you chose this for now)
    room_goto(_room);
}
