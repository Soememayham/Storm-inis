/// OBJ_OVERWORLD_SPAWN_CTRL — Step
var dt = clamp(delta_time * 0.000001, 0, 0.05);

// 1) Keep population topped up
var alive_now = instance_number(OBJ_ENEMY);
var deficit   = max(0, target_count - alive_now);

// If enemies were removed (e.g., you entered a battle and enemy got destroyed),
// request more spawns. Keep pending at least as large as the current deficit.
if (deficit > pending_to_spawn) {
    pending_to_spawn = deficit;
}

// 2) Stagger spawns over time
spawn_timer -= dt;

if (pending_to_spawn > 0 && spawn_timer <= 0) {
    // Pick spawn location
    var p = _pick_spawn_point();
    var sx = p[0], sy = p[1];

    // Create the overworld enemy
    var e = instance_create_layer(sx, sy, "Instances", OBJ_ENEMY);

    // Initialize encounter-related fields (modular & future-proof)
    with (e) {
        // Region tag (string) — used later for encounter variety
        region       = string(global.overworld_region); 

        // Encounter group id for the battle (includes TINI id 4)
        encounter_id = other._choose_encounter_id();

        // Optional min/max size for the battle group (change as you like)
        min_group    = 1;
        max_group    = 3;

        // Wander AI defaults (tweak to taste)
        if (!variable_instance_exists(id, "move_speed")) move_speed = 80;
        if (!variable_instance_exists(id, "sight_range")) sight_range = 220; // they won't chase—your object already triggers battle on touch
        if (!variable_instance_exists(id, "stop_range")) stop_range = 12;    // battle trigger range safety
    }

    // Next spawn time (staggered)
    spawn_timer = random_range(stagger_min, stagger_max);
    pending_to_spawn -= 1;
}
