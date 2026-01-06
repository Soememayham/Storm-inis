global.player = id;
global.in_battle = false;


// --- Movement tuning
move_speed  = 180;     // top speed (px/s)
accel_rate  = 2200;    // accel toward target (px/s^2)
decel_rate  = 2400;    // decel toward 0/target (px/s^2)

// --- State
vx = 0;
vy = 0;
direction = 0;         // built-in; keep a sane default
_lastdir  = 0;         // <— initialize so Step can read it
localFrame = 0;        // since your code references this

// --- Sprites (REPLACE with your resource names)
spr_idle = SPR_OVERWORLD_idle;   // e.g., spr_char_idle
spr_walk = SPR_OVERWORLD_WALK;   // e.g., spr_char_walk
