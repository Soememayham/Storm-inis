// ===============================
// ENEMY CREATE — Setup & Defaults
// ===============================

// --- Stats (fallbacks if none injected) ---
if (!variable_instance_exists(id, "stats")) {
    stats = { name:"Enemy", hp:20, hp_max:20, atk:5, def:1, spd:120 };
}
if (!variable_struct_exists(stats, "hp_max")) stats.hp_max = stats.hp;

// --- Movement / AI tuning ---
move_speed    = stats.spd; // used for chase + lunge base
detect_range  = 80;        // start chasing if within this distance
attack_range  = 28;        // must be at/inside to start attack

// --- Attack timing ---
attack_cd_max = 1.0;       // cooldown after a full attack cycle
attack_cool   = 0.0;       // current cooldown timer

// Telegraph (flash warning) — standard 0.3s
telegraph_dur = 0.30;
telegraph_t   = 0.0;       // counts down during telegraph

// --- State & flags ---
// 0 = idle/chase, 1 = attack (telegraph→lunge→recover), 2 = recover
state       = 0;
attack_done = false;       // prevent a second hit this swing
charge_dir  = 0;           // attack direction locked at attack start

// --- Hit/interrupt support ---
just_hit = false;          // set true by your damage system when enemy is hit

// --- Optional knockback variables (if you use enemy KB elsewhere) ---
kb_t = 0; kb_spd = 0; kb_dir = 0;

// ===============================
// Assign Enemy Sprite Variants
// ===============================
spr_idle   = SPR_Mini_Battle_Enemy_Idle;   // Replace with your actual idle sprite
spr_walk   = SPR_Mini_Battle_Enemy_Walk;   // Replace with your walking sprite
spr_attack = SPR_Mini_Enemy_Battle_Charge; // Replace with attack sprite


// Let the step/anim scripts control speeds
image_speed = 0;
