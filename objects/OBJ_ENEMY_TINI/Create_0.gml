// ===============================
// OBJ_ENEMY_TINI — Create (Battle-only)
// Trickster AI: hover → dash → dropkick → random retreat → repeat
// ===============================

// --- Core stats (balanced)
stats = {
    name: "Tini",
    hp: 10, hp_max: 10,
    atk: 2, def: 4, spd: 4
};

// --- AI state machine
// 0=Hover, 1=Approach, 2=Attack, 3=Retreat, 4=Hurt, 5=Dead
state = 0;

// --- Movement tuning (px/sec; scaled from spd for feel)
move_hover_spd   = 60 + stats.spd * 8;   // lazy circle speed
move_approach_spd= 95 + stats.spd * 15;  // quick dash-in
move_retreat_spd = 120 + stats.spd * 18; // snappy pullback

// --- Ranges (px)
hover_min = 96;          // prefer to stay outside this
hover_max = 144;         // prefer to stay within this
attack_range = 26;       // will try to attack inside this

// --- Timers
cooldown = 0;            // time until next engage (sec)
ifr_time = 0; ifr_max = 0.25; // brief i-frames when hurt

// --- Attack bookkeeping
attack_hit_done = false; // ensure only 1 hit per attack
attack_dir = 0;          // locked for current attack
retreat_t = 0;           // timer for retreat burst

// --- Sprites (you said these are already assigned; keep as fallback)
if (!variable_instance_exists(id,"spr_idle"))  spr_idle   = SPR_TINI_ENEMY_IDLE;
spr_walk   = SPR_TINI_ENEMY_WALK;
if (!variable_instance_exists(id,"spr_attack")) spr_attack = SPR_TINI_ENEMY_DROPKICK;

// animation defaults
sprite_index = spr_idle;
image_speed  = 0.2;

// facing cache (degrees) – keeps L/R split logic stable
facing = 0;

// small jitter so multiples don't sync perfectly
engage_delay = irandom_range(0, 12) * 0.01;

// knockback (optional hook with your engine)
kb_t = 0; kb_spd = 0; kb_dir = 0;
just_hit = false;
