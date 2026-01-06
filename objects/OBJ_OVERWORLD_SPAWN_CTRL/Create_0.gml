// -------- Overworld Spawn Controller Create --------
max_enemies          = 8;             // cap per room
spawn_check_interval = 2.0;           // seconds between spawn attempts
timer                = 0;

respawn_min = 120; // 2 minutes
respawn_max = 300; // 5 minutes


function _choose_encounter_id() {
    switch (string(global.overworld_region)) {
        case "forest":
            return choose(1,4); // 👈 MUST include 4
        default:
            return choose(1,4);
    }
}
