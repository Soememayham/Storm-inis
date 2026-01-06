// ======================================================
// ENEMY STEP — Telegraph → Full Lunge (single hit) → Recover
// 36f sheet (18R + 18L) via local frame = floor(image_index) mod 18
// Uses global.player; attack can be interrupted (snap to idle)
// ======================================================

var dt = clamp(delta_time * 0.000001, 0, 0.05);

// Cooldown tick
attack_cool = max(0, attack_cool - dt);

// Resolve player once via global (fast)
var pl = (is_undefined(global.player) || !instance_exists(global.player)) ? noone : global.player;

// Distance & direction to player (if exists)
var dist_to_pl = 9999;
if (pl != noone) {
    dist_to_pl = point_distance(x, y, pl.x, pl.y);
}

// ============================
// INTERRUPT: got hit → cancel
// ============================
if (just_hit) {
    // Cancel any current attack and snap to idle/chase
    state        = 0;
    attack_done  = false;
    telegraph_t  = 0;
    image_index  = 0;
    image_speed  = 0;
    attack_cool  = max(attack_cool, 0.25); // brief grace so they don't instantly re-attack
    just_hit     = false;                  // consume the flag
}

// ============================
// Simple chase movement (State 0)
// ============================
switch (state) {
    // ───────────────────────────────────────────────
    // 0) IDLE / CHASE
    // ───────────────────────────────────────────────
    case 0:
    {
        if (pl != noone) {
            var dir = point_direction(x, y, pl.x, pl.y);

            // Move if outside attack range
            var must_chase = (dist_to_pl > attack_range);
            if (must_chase) {
                // Move with dt (px/sec style)
                var step_spd = move_speed * dt;
                x += lengthdir_x(step_spd, dir);
                y += lengthdir_y(step_spd, dir);
            }

            // Try to start attack if close & not cooling
            if (dist_to_pl <= attack_range && attack_cool <= 0) {
                state        = 1;          // enter attack state
                telegraph_t  = telegraph_dur;
                image_index  = 0;          // start attack anim from beginning
                image_speed  = 0;          // freeze frames during telegraph
                attack_done  = false;
                charge_dir   = dir;        // 🔒 lock direction at attack start
            }

            // Face player while idling/chasing
            direction = dir;
        }
        // animation speeds (snappy)
        image_speed = 0.2; // idle
    }
    break;

    // ───────────────────────────────────────────────
    // 1) ATTACK: Telegraph → Lunge (burst+charge) → Finish
    // ───────────────────────────────────────────────
    case 1:
    {
        // • Phase A: TELEGRAPH (flash red, hold frames)
        if (telegraph_t > 0) {
            telegraph_t = max(0, telegraph_t - dt);

            // Flash red → white (visual tell). Pulse at ~10Hz.
            var pulse = (1 + sin(current_time * 0.006)) * 0.5;
            image_blend = merge_color(c_white, c_red, pulse * 0.8);

            // Freeze on first attack frame visually
            sprite_index = spr_attack;
            image_index  = 0;     // stay on frame 0 during telegraph
            image_speed  = 0;

            // Keep facing locked
            direction    = charge_dir;

            // When telegraph ends, start lunge frames
            if (telegraph_t == 0) {
                image_blend = c_white;
                image_speed = 0.7;  // enemy attack anim speed (snappy; adjust 0.6–0.9)
            }
        }
        else
        {
            // • Phase B: LUNGE / STRIKE / RECOVER using local frames (0..17 per side)
            sprite_index = spr_attack;

            var local_frame = floor(image_index) mod 18;

            // Movement curve:
            // 4–6: burst; 6–14: charge; 15–17: taper; 0–3: no move
            var spd_mult = 0;
            if (local_frame >= 4 && local_frame <= 6)  spd_mult = 1.9; // burst
            else if (local_frame > 6 && local_frame <= 14) spd_mult = 1.5; // charge
            else if (local_frame >= 15)                spd_mult = 0.4; // taper
            else                                       spd_mult = 0.0; // startup

            // Apply movement along locked charge_dir
            if (spd_mult > 0) {
                var step_spd = (move_speed * spd_mult) * dt; // px/sec * dt
                x += lengthdir_x(step_spd, charge_dir);
                y += lengthdir_y(step_spd, charge_dir);
            }

            // SINGLE STRIKE: precise hit once at local frame 8
            if (!attack_done && local_frame == 8 && pl != noone) {
                // Ensure target is still close enough
                var dnow = point_distance(x, y, pl.x, pl.y);
                if (dnow <= attack_range + 8) {
                    // Apply damage + medium knockback to player
                    SCRIPT_ENEMY_HIT_PLAYER(id, pl, charge_dir);
                    attack_done = true;
                }
            }

            // Finish attack when local frame ≥ 17 (end of this side’s strip)
            if (local_frame >= 17) {
                state       = 2;           // recover
                attack_cool = attack_cd_max;
                image_speed = 0;           // stop anim during recover
                image_index = 0;
                image_blend = c_white;
            }
        }
    }
    break;

    // ───────────────────────────────────────────────
    // 2) RECOVER — brief pause, then back to chase
    // ───────────────────────────────────────────────
    case 2:
    {
        // Stand still briefly (cooldown is ticking above)
        // When done, go back to chase/idle
        if (attack_cool <= 0) {
            state = 0;
        }
        image_speed = 0.2; // idle anim while recovering
    }
    break;
}

// ============================
// Directional animation helper
// (Uses your own script that slices L/R)
// ============================
if (state == 1 && telegraph_t <= 0) {
    // Running attack anim frames
    SCRIPT_ENEMY_BATTLE_ANIM(spr_attack, 2, charge_dir);
}
else if (pl != noone && point_distance(x,y,pl.x,pl.y) > attack_range) {
    // Chase anim
    SCRIPT_ENEMY_BATTLE_ANIM(spr_walk, 1, point_direction(x,y,pl.x,pl.y));
}
else {
    // Idle anim
    SCRIPT_ENEMY_BATTLE_ANIM(spr_idle, 0, direction);
}

// Reset flash outside of telegraph/hurt
if (telegraph_t <= 0 && !just_hit) image_blend = c_white;

// Death cleanup
if (stats.hp <= 0) {
    instance_destroy();
}
