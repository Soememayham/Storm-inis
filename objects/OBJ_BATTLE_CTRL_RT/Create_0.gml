// ======================================================
// OBJ_BATTLE_CTRL_RT — CREATE EVENT (FINAL & CLEAN)
// Auto-Positions Enemies | Supports Multi-TINI
// ======================================================

// --- Ensure only one battle controller
if (instance_number(object_index) > 1) {
    if (id != instance_find(object_index, 0)) { instance_destroy(); exit; }
}

// --- Cleanup any possible leftovers
with (OBJ_PL_MINI_BATTLE) instance_destroy();
with (OBJ_CHAR_OVERWORLD) instance_destroy();

// --- No battle payload? Return to previous room
if (is_undefined(global.battle)) {
    show_debug_message("No battle payload — returning.");
    room_goto_previous();
    exit;
}

var payload     = global.battle;
var enemy_types = payload.enemy_types;
var pl_stats    = payload.player_stats;

// ============================================
// PLAYER SPAWN POSITION (auto)
// ============================================
var plx = room_width  * 0.25;
var ply = room_height * 0.65;

// --- Spawn battle player (JUST ONCE!)
var pl_b = instance_create_layer(plx, ply, "Instances", OBJ_PL_MINI_BATTLE);
global.player = pl_b;
global.in_battle = true;

// --- Apply stored player stats (carry HP, etc.)
if (!is_undefined(pl_stats) && is_struct(pl_stats)) {
    if (variable_instance_exists(pl_b, "stats")) {
        pl_b.stats = pl_stats; // Full struct restore
    }
}

// ============================================
// CAMERA FOLLOW (OBJ_CAMERA_original only)
// ============================================
var cam = instance_find(OBJ_CAMERA_original, 0);
if (instance_exists(cam)) {
    cam.follow_id = pl_b;
}

// ============================================
// ENEMY SPAWN — AUTO POSITION (FORMATION)
// ============================================
var N = array_length(enemy_types);
for (var i = 0; i < N; i++) {
    var ex = plx + 140 + (56 * i);
    var ey = ply - 80;
    instance_create_layer(ex, ey, "Instances", enemy_types[i]);
}

