// ======================================================
// OBJ_ENEMY_TINI — STEP (Battle-only Trickster)
// Hover → Approach → Dropkick → Retreat → Repeat
// Full-sheet animation + xscale flip; single-hit (frames 2–7)
// ======================================================

var dt = clamp(delta_time * 0.000001, 0, 0.05);

// --- references
var pl = (variable_global_exists("player") && instance_exists(global.player)) ? global.player : noone;
if (pl == noone) exit;

// --- timers
ifr_time  = max(0, ifr_time - dt);
cooldown  = max(0, cooldown - dt);
engage_delay = max(0, engage_delay - dt);

// --- distance/facing
var dist = point_distance(x, y, pl.x, pl.y);
var dir  = point_direction(x, y, pl.x, pl.y);

// Face player using xscale (like your other characters)
image_xscale = (pl.x < x) ? -1 : 1;
facing = dir; // keep for consistency if other systems read it

// --- optional light KB if your engine uses it
if (kb_t > 0) {
    var step_kb = kb_spd * dt;
    x += lengthdir_x(step_kb, kb_dir);
    y += lengthdir_y(step_kb, kb_dir);
    kb_t -= dt;
}

// ======================================================
// STATE MACHINE
// 0=Hover, 1=Approach, 2=Attack, 3=Retreat, 4=Hurt, 5=Dead
// ======================================================
switch (state)
{
    // 0 — HOVER (nervous bounce holding ring around player)
    case 0:
    {
        // keep within [hover_min .. hover_max]
        if (dist > hover_max) {
            var s = move_hover_spd * dt;
            x += lengthdir_x(s, dir);
            y += lengthdir_y(s, dir);
        } else if (dist < hover_min) {
            var away = point_direction(pl.x, pl.y, x, y);
            var s = move_hover_spd * dt;
            x += lengthdir_x(s, away);
            y += lengthdir_y(s, away);
        }

        if (engage_delay <= 0 && cooldown <= 0 && dist <= hover_max + 8) {
            state = 1; // start sliding toward player
        }
    }
    break;

    // 1 — APPROACH (quick slide in)
    case 1:
    {
        var s1 = move_approach_spd * dt;
        x += lengthdir_x(s1, dir);
        y += lengthdir_y(s1, dir);

        if (dist <= attack_range) {
            // lock attack
            attack_dir = dir;
            attack_hit_done = false;
            image_index = 0;
            state = 2;
        }

        // lost distance → go back to hover and try again
        if (dist > hover_max + 48) {
            state = 0;
            cooldown = 0.4;
        }
    }
    break;

    // 2 — ATTACK (dropkick; single hit in frames 2..7)
    case 2:
    {
        // drift forward while kicking
        var s2 = (move_approach_spd + 40) * 0.6 * dt;
        x += lengthdir_x(s2, attack_dir);
        y += lengthdir_y(s2, attack_dir);

        // LOCAL frame index (full-sheet; no splitting)
        var local = floor(image_index); // 0..(sprite_get_number-1)

        // Single-hit window: frames 2..7 inclusive
        if (!attack_hit_done && local >= 2 && local <= 7) {
            attack_hit_done = true;

            if (point_distance(x, y, pl.x, pl.y) <= attack_range + 10) {
                if (!is_undefined(SCRIPT_ENEMY_HIT_PLAYER)) {
                    SCRIPT_ENEMY_HIT_PLAYER(id, pl);
                }
            }
        }

        // attack anim finished → retreat
        if (local >= sprite_get_number(SPR_TINI_ENEMY_DROPKICK) - 1) {
            state       = 3;
            retreat_t   = 0.22 + irandom_range(0, 8) * 0.01;
            retreat_dir = irandom(359);
            cooldown    = 0.7;
        }
    }
    break;

    // 3 — RETREAT (quick pop away; then hover)
    case 3:
    {
        var s3 = move_retreat_spd * dt;
        x += lengthdir_x(s3, retreat_dir);
        y += lengthdir_y(s3, retreat_dir);

        retreat_t -= dt;
        if (retreat_t <= 0) {
            state = 0;
            engage_delay = random_range(0.15, 0.35);
        }
    }
    break;

    // 4 — HURT (no custom sprites yet; brief stumble)
    case 4:
    {
        ifr_time = max(ifr_time, 0.10);
        state = 0;
    }
    break;

    // 5 — DEAD handled below
}

// --- death → vanish w/ puff
if (stats.hp <= 0) {
    if (object_exists(OBJ_PUFF_SMALL)) {
        instance_create_layer(x, y, "Instances", OBJ_PUFF_SMALL);
    }
    instance_destroy();
    exit;
}

// --- hurt flash
if (just_hit) image_blend = c_red; else image_blend = c_white;
just_hit = false;

// ======================================================
// ANIMATION: full-sheet + xscale (no splitting math)
// ======================================================
var anim = {
    state: state,
    just_hit: (ifr_time > 0),
    dead: (stats.hp <= 0),

    spr_idle:   spr_idle,    // animated idle
    spr_walk:   spr_walk,    // full walk sheet
    spr_attack: spr_attack   // full attack sheet
};

SCRIPT_TINI_BATTLE_ANIM(anim);
