// ==============================================
// OBJ_ENEMY — Step (Overworld Chase + Touch > Battle)
// ==============================================
var dt = clamp(delta_time * 0.000001, 0, 0.05);

// Resolve player (global pointer)
var pl = (!is_undefined(global.player) && instance_exists(global.player)) ? global.player : noone;
if (pl == noone) exit; // nothing to do without a player

var dist = point_distance(x, y, pl.x, pl.y);
var dir  = point_direction(x, y, pl.x, pl.y);

// --- Facing the player (you asked for this)
if (face_mode_rotate) {
    image_angle = dir;  // rotates sprite toward player
} else if (face_mode_flip) {
    // Simple horizontal flip, if you use side-view sprites
    image_xscale = (abs(angle_difference(dir, 0)) <= 90) ? 1 : -1;
}

// --- State machine
switch (state) {
    // ─────────────────────────────
    // IDLE — player is far away
    // ─────────────────────────────
    case 0:
        if (dist <= sight_range) state = 1; // start chasing
        break;

    // ─────────────────────────────
    // CHASE — close the distance
    // ─────────────────────────────
    case 1:
        // move toward player
        var step_spd = move_speed * dt;
        x += lengthdir_x(step_spd, dir);
        y += lengthdir_y(step_spd, dir);

        // Touch / close-enough check → freeze & start battle
        if (place_meeting(x, y, pl) || dist <= stop_range) {
            state = 2;
            // Freeze motion (visual)
            // (Not strictly necessary since we'll change rooms immediately.)
            // But it honors your "freeze on touch" request.
            // Optional: set an idle frame/sprite here if needed.
            SCRIPT_START_BATTLE_FROM_ENEMY(id);
            exit;
        }

        // Lost sight → back to idle
        if (dist > sight_range + 40) state = 0; // small hysteresis
        break;

    // ─────────────────────────────
    // FREEZE — waiting for transition
    // ─────────────────────────────
    case 2:
        // Do nothing; SCRIPT_START_BATTLE_FROM_ENEMY will room_goto()
        break;
}
