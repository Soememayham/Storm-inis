// Example enemy kind constants (define elsewhere, e.g., macros)
var kind = ENEMY_Mimic;

// Get enemy data (see step 3)
var estats = scr_enemy_data(kind);

// Start battle
obj_game.start_battle(kind, estats);
