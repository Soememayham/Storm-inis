// ======================================================
// PLAYER STEP EVENT — FINAL (Burst Charge + Multi-Hit)
// ======================================================

// === Delta Time ===
var dt = clamp(delta_time * 0.000001, 0, 0.05);

// === INPUT (Disabled ONLY during attack) ===
var ix = 0, iy = 0;
if (attack_phase == 0) { // Allow input ONLY if not attacking
    ix = keyboard_check(vk_right) - keyboard_check(vk_left);
    iy = keyboard_check(vk_down)  - keyboard_check(vk_up);
}

// === Normalize Movement Input ===
var len = sqrt(ix * ix + iy * iy);
var moving = (len > 0);
if (len > 0) { ix /= len; iy /= len; }

// === Target Velocity ===
var tx = moving ? ix * move_speed : (attack_phase == 0 ? 0 : vx);
var ty = moving ? iy * move_speed : (attack_phase == 0 ? 0 : vy);

var ax = (abs(tx) > abs(vx)) ? accel_rate : decel_rate;
var ay = (abs(ty) > abs(vy)) ? accel_rate : decel_rate;

var dx = tx - vx; var step_x = ax * dt;
vx = (abs(dx) <= step_x) ? tx : vx + sign(dx) * step_x;

var dy = ty - vy; var step_y = ay * dt;
vy = (abs(dy) <= step_y) ? ty : vy + sign(dy) * step_y;

// === Movement & Collision ===
x += vx * dt;
if (!place_free(x, y)) {
    var sx = sign(vx * dt);
    while (!place_free(x - sx, y)) x -= sx;
    vx = 0;
}

y += vy * dt;
if (!place_free(x, y)) {
    var sy = sign(vy * dt);
    while (!place_free(x, y - sy)) y -= sy;
    vy = 0;
}

// === Update Facing (Only if NOT attacking) ===
if (moving && attack_phase == 0) {
    facing = point_direction(0, 0, vx, vy);
}


// ======================================================
// ATTACK SYSTEM — 36f (18R+18L) Burst Charge + Multi-Hit
// ======================================================

// --- Attack Input ---
if (keyboard_check_pressed(ord("O")) && attack_phase == 0 && stats.hp > 0) {
    state = 2;
    attack_phase = 1;        // start-up
    image_index = 0;
    image_speed = 0.1;
    charge_dir = facing;     // lock direction
    attack_hits = 0;         // for weakened knockback scaling
}

// --- Attack Phase Control ---
switch (attack_phase) {

    case 1: // 🟦 START-UP (local frames 0–3)
        {
            var frame = floor(image_index) mod 18;  // local frame within R/L half
            if (frame >= 3) attack_phase = 2;       // begin CHARGE at local frame 4
        }
        break;

    case 2: // 🟥 CHARGE (local frames 4–14)  — includes Burst 4–6 and Multi-Hit 6–14
        {
            var frame = floor(image_index) mod 18;

            // --- Burst Acceleration (frames 4–6) ---
            var spd_mult = (frame <= 6) ? 1.9 : 1.5; // extra push early for impact
            vx = lengthdir_x(move_speed * spd_mult, charge_dir);
            vy = lengthdir_y(move_speed * spd_mult, charge_dir);

            // --- Multi-Hit Precise Window (frames 6–14), per frame ---
            if (frame >= 6 && frame <= 14) {
                SCRIPT_HIT_ENEMY(id, charge_dir, frame); // per-frame hit
            }

            // --- Move to taper at local frame 15 ---
            if (frame >= 15) attack_phase = 3;
        }
        break;

    case 3: // 🟨 TAPER (local frames 15–17)
        {
            vx *= 0.4;
            vy *= 0.4;

            // Exit at end of local frame 17 (i.e., frame 18 of this half)
            var frame = floor(image_index) mod 18;
            if (frame >= 17) {
                attack_phase = 0;
                state = 0;
                anim_force_reset = true; // ensure animator releases

                // === Resume movement cleanly (no forced sliding)
                var ixx = keyboard_check(vk_right) - keyboard_check(vk_left);
                var iyy = keyboard_check(vk_down)  - keyboard_check(vk_up);
				var input_len = sqrt(ixx*ixx + iyy*iyy);
			if (input_len > 0) {
				vx = (ixx / input_len) * move_speed;
				vy = (iyy / input_len) * move_speed;
			} else {
				vx *= 0.85;
				vy *= 0.85;
				}

            }
        }
        break;
}


// ======================================================
// PLAYER STATE MACHINE
// ======================================================
if (stats.hp <= 0) {
    state = 4;
}
else if (just_hit) {
    state = 3;
}
else if (attack_phase > 0) {
    state = 2;  // Attack
}
else if (moving) {
    state = 1;  // Run
}
else {
    state = 0;  // Idle
}


// ======================================================
// ANIMATION CONTEXT FOR SCRIPT_BATTLE_ANIM
// ======================================================
var anim = {
    state: state,
    state_t: state_t,
    moving: moving,
    facing: facing,
    speed_norm: clamp(point_distance(0, 0, vx, vy) / max(1, move_speed), 0, 1),

    attack_phase: attack_phase,
    just_hit: just_hit,
    dead: (stats.hp <= 0),

    spr_idle:   spr_idle,
    spr_run:    spr_run,
    spr_attack: spr_attack,
    spr_hurt:   spr_hurt,
    spr_die:    spr_die,

    anim_force_reset: anim_force_reset
};

// === Hurt Flash ===
if (just_hit) image_blend = c_red;
else image_blend = c_white;
just_hit = false;

// === Animate (handles L/R slicing and speeds) ===
SCRIPT_BATTLE_ANIM(anim);

// Reset animation force flag after use
anim_force_reset = false;

