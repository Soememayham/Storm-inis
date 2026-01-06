/// OBJ_BATTLE_CTRL_RT -> Step

// Get the current player pawn (first instance)
var pl = instance_exists(OBJ_PL_MINI_BATTLE) ? instance_find(OBJ_PL_MINI_BATTLE, 0) : noone;

// ---------- Lose condition ----------
var player_dead = false;
if (pl == noone) {
    player_dead = true;
} else {
    // guard if stats missing
    var pl_hp = (variable_instance_exists(pl, "stats") && variable_struct_exists(pl.stats, "hp")) ? pl.stats.hp : 0;
    player_dead = (pl_hp <= 0);
}

if (player_dead) {
    if (variable_global_exists("Game") && instance_exists(global.Game)) {
        global.Game.end_battle("lose");
    }
    exit; // stop further checks this step
}

// ---------- Win condition ----------
if (instance_number(OBJ_ENEMY_MINI_BATTLE) == 0) {
    if (pl != noone && variable_global_exists("Game") && instance_exists(global.Game)) {
        // write back HP safely
        var pl_hp_now = (variable_instance_exists(pl, "stats") && variable_struct_exists(pl.stats, "hp")) ? pl.stats.hp : 0;
        global.Game.player.hp = clamp(pl_hp_now, 0, global.Game.player.hp_max);
        global.Game.end_battle("win");
    }
}


// =====================
// BATTLE END DETECTOR
// =====================
if (instance_number(OBJ_ENEMY_MINI_BATTLE) == 0 &&
    instance_number(OBJ_ENEMY_TINI) == 0) {

    // All enemies defeated → Exit battle!
    if (!is_undefined(SCRIPT_BATTLE_END)) {
        SCRIPT_BATTLE_END(true);
    }
}
