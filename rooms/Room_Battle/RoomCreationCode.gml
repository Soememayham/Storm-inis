// ---------------------------------------------------------
// Ensure the persistent game manager exists and is reachable
// ---------------------------------------------------------
if (!variable_global_exists("Game") || !instance_exists(global.Game)) {
    global.Game = instance_create_layer(0, 0, "Instances", OBJ_Game);
}
var G = global.Game;

// (Optional safety) make sure no overworld pawn survived into the battle room ✅
if (instance_exists(OBJ_CHAR_OVERWORLD)) with (OBJ_CHAR_OVERWORLD) instance_destroy();

// ---------------------------------------------------------
// SPAWN: Player battle pawn (OBJ_PL_MINI_BATTLE)
// ---------------------------------------------------------
//var P  = G.player;
//var pl = instance_create_layer(160, 240, "Instances", OBJ_PL_MINI_BATTLE);

//with (pl) {
//    if (!variable_instance_exists(id, "stats")) stats = {};
//    stats.hp      = is_undefined(P.hp)      ? 30  : P.hp;
//    stats.hp_max  = is_undefined(P.hp_max)  ? 30  : P.hp_max;
//    stats.atk     = is_undefined(P.atk)     ? 6   : P.atk;
//    stats.def     = is_undefined(P.def)     ? 2   : P.def;
//    stats.spd     = is_undefined(P.spd)     ? 220 : P.spd;

    // KB/i-frames defaults so Step never reads undefined (harmless if already set) ✅
//    if (!variable_instance_exists(id,"kb_t"))   { kb_t = 0; kb_spd = 0; kb_dir = 0; }
//    if (!variable_instance_exists(id,"ifr_max")) ifr_max = 0.40;
//    if (!variable_instance_exists(id,"ifr_time")) ifr_time = 0;
//}

// Tell the camera who to follow during battle ✅
//G.follow_id = pl;

// ---------------------------------------------------------
// SPAWN: Enemy battle pawn (OBJ_ENEMY_MINI_BATTLE)
// ---------------------------------------------------------
var est = is_struct(G.battle.enemy_stats) ? G.battle.enemy_stats : {};
if (!variable_struct_exists(est, "name"))   est.name   = "Enemy";
if (!variable_struct_exists(est, "hp"))     est.hp     = 12;
if (!variable_struct_exists(est, "hp_max")) est.hp_max = est.hp;
if (!variable_struct_exists(est, "atk"))    est.atk    = 4;
if (!variable_struct_exists(est, "def"))    est.def    = 1;
if (!variable_struct_exists(est, "spd"))    est.spd    = 140;

var en = instance_create_layer(480, 240, "Instances", OBJ_ENEMY_MINI_BATTLE);
with (en) {
    stats = est;
    // Same safe defaults for enemy ✅
    if (!variable_instance_exists(id,"kb_t"))   { kb_t = 0; kb_spd = 0; kb_dir = 0; }
    if (!variable_instance_exists(id,"ifr_max")) ifr_max = 0.20;
    if (!variable_instance_exists(id,"ifr_time")) ifr_time = 0;
}

// ---------------------------------------------------------
// Ensure the battle controller exists
// ---------------------------------------------------------
//if (!instance_exists(OBJ_BATTLE_CTRL_RT)) {
//    instance_create_layer(0, 0, "Instances", OBJ_BATTLE_CTRL_RT);
//}
