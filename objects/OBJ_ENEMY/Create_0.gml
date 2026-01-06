// ===============================
// OBJ_ENEMY — Create (Overworld)
// ===============================

// --- Encounter tuning (set per-instance in Room Editor or leave these defaults)
if (!variable_instance_exists(id,"region"))       region       = "plains";
if (!variable_instance_exists(id,"encounter_id")) encounter_id = 1;
if (!variable_instance_exists(id,"min_group"))    min_group    = 1;
if (!variable_instance_exists(id,"max_group"))    max_group    = 3;

encounter_id = choose(1, 4); // Now includes your TINI


// --- Chase / detection tuning (px / px-sec)
move_speed  = 90;     // chase speed (pixels per second)
sight_range = 320;    // begin chasing if player is within this range
stop_range  = 16;     // treat as "touch" at or inside this distance

// --- Facing mode
face_mode_rotate = true;   // true = rotate sprite (image_angle)
face_mode_flip   = false;  // set true if you prefer left/right flip instead

// --- Internal state
state = 0;  // 0=idle, 1=chase, 2=freeze


show_debug_message("Enemy created with encounter_id = " + string(encounter_id));

