/// OBJ_OVERWORLD_SPAWN_CTRL — Create
/// Modular overworld spawner (staggered). Keeps target_count enemies alive.

/// --- GLOBAL REGION DEFAULT (so we never crash)
if (!variable_global_exists("overworld_region")) {
    global.overworld_region = "forest"; // your starting area name
}

/// --- TUNABLES (make this modular later via room vars if you want)
target_count = 3;            // how many overworld enemies to keep alive
stagger_min  = 0.30;         // seconds between spawns (min)
stagger_max  = 0.90;         // seconds between spawns (max)
edge_margin  = 32;           // don't spawn hugging room edges
avoid_player_radius = 96;    // try not to spawn right on top of player
max_pick_tries = 20;         // attempts to find a good spawn point

/// --- INTERNAL
pending_to_spawn = target_count; // initial wave spawns staggered
spawn_timer      = 0;            // countdown until next spawn

/// --- OPTIONAL: region-weighted encounter chooser
function _choose_encounter_id() {
    // Keep simple for now; include your TINI id (4)
    // swap to a region-weighted switch later
    switch (string(global.overworld_region)) {
        case "forest":
            // Heavier on “mini”, sometimes TINI
            return choose(1,1,1,2,3,4);
        default:
            return choose(1,2,3,4);
    }
}

/// --- Safe random point (tries to avoid player & edges)
function _pick_spawn_point() {
    var _x = irandom_range(edge_margin, room_width  - edge_margin);
    var _y = irandom_range(edge_margin, room_height - edge_margin);

    var pl = (variable_global_exists("player") && instance_exists(global.player)) ? global.player : noone;

    var tries = 0;
    while (tries < max_pick_tries) {
        _x = irandom_range(edge_margin, room_width  - edge_margin);
        _y = irandom_range(edge_margin, room_height - edge_margin);

        if (pl != noone) {
            if (point_distance(_x, _y, pl.x, pl.y) >= avoid_player_radius) break;
        } else {
            break;
        }
        tries++;
    }
    return [_x, _y];
}
