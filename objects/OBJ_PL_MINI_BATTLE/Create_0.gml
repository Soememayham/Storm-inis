global.player = id;
global.in_battle = true;

// Tunables
move_speed   = 220;  accel_rate = 2600; decel_rate = 3000;
atk_damage   = 6;    atk_cooldown = 0.25; atk_life = 0.10;
atk_range    = 18;   atk_kb = 240;        atk_kbdur = 0.10;

// Attack timing windows (seconds)
atk_wind    = 0.08;   // wind-up before hit
atk_active  = 0.12;   // hit frames (hitbox lifetime if you like)
atk_recover = 0.12;   // post-swing

// State
vx = 0; vy = 0; facing = 1; next_attack_time = 0;
ifr_max = 0.40; ifr_time = 0;

// Stats (fallback if not injected)
if (!variable_instance_exists(id, "stats")) {
    stats = { hp:30, hp_max:30, atk:atk_damage, def:2, spd:move_speed };
}
move_speed = (is_undefined(stats.spd) ? move_speed : stats.spd);
atk_damage = (is_undefined(stats.atk) ? atk_damage : stats.atk);

anim_force_reset = false; // you already added this earlier
attack_hits = 0;          // used by SCRIPT_HIT_ENEMY to scale knockback


// Knockback defaults
kb_t = 0; kb_spd = 0; kb_dir = 0;

// Sprites (replace with your resources)
spr_idle   = SPR_Mini_Battle_idle;
spr_run    = SPR_Mini_Battle_Walk;    // <-- use spr_run (not spr_walk) for the anim system
spr_attack = SPR_Mini_Battle_Charge;
spr_hurt   = SPR_Mini_Battle_Hurt;
spr_die    = SPR_Mini_Battle_Die;

// Simple FSM
enum BState { IDLE, RUN, ATTACK, HURT, DIE }
state = BState.IDLE;
state_t = 0;
attack_phase = 0;          // 0=None 1=Wind 2=Active 3=Recover
atk_hitbox_spawned = false;
just_hit = false;

image_speed = 0; // slower, smoother animation control

